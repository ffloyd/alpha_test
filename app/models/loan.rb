class Loan < ApplicationRecord
  BASE_DURATION       = 6
  BASE_PERIOD         = 1 # TODO: currently ignored in formulas
  BASE_ANNUAL_RATE    = 0.3
  BASE_DELIQENCY_RATE = 0.5

  has_many :payments

  validates :legal_entity,
            :amount,
            :period,
            :duration,
            :annual_rate,
            :deliquency_rate, presence: true

  after_initialize :assign_defaults

  # basic calculated values

  def monthly_debt_payment
    amount / duration
  end

  def monthly_perc_payment
    amount * annual_rate / 12
  end

  def monthly_deliquency_perc_payment
    amount * deliquency_rate / 12
  end

  def monthly_payment
    monthly_debt_payment + monthly_perc_payment
  end

  def monthly_deliquency_payment
    monthly_debt_payment + monthly_deliquency_perc_payment
  end

  # payments dependent calculated values and methods

  def add_next_payment!(deliquency: false)
    raise 'Loan already paid' if paid?
    next_month = (payments.maximum(:month) || 0) + 1
    payments.create(month: next_month, deliquency: deliquency)
  end

  def paid?
    payments.count == duration
  end

  def paid_perc
    normal_payments     = payments.where(deliquency: false).count
    deliquency_payments = payments.where(deliquency: true).count

    (monthly_perc_payment * normal_payments) + (monthly_deliquency_perc_payment * deliquency_payments)
  end

  def paid_debt
    monthly_debt_payment * payments.count
  end

  def result_rate
    (paid_perc / paid_debt) * (12.0 / payments.count)
  end

  private

  def assign_defaults
    assign_attributes duration:         BASE_DURATION,
                      period:           BASE_PERIOD,
                      annual_rate:      BASE_ANNUAL_RATE,
                      deliquency_rate:  BASE_DELIQENCY_RATE
  end
end