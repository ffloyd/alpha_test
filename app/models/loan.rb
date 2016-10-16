class Loan < ApplicationRecord
  include HumanReaders

  BASE_DURATION       = 6
  BASE_PERIOD         = 1 # TODO: currently ignored in formulas
  BASE_ANNUAL_RATE    = 0.3
  BASE_DELIQENCY_RATE = 0.5

  has_many :payments, dependent: :destroy

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

  def add_next_payment!(deliquency: false, pay_all: false)
    raise 'Loan already paid' if paid?
    next_month = (payments.maximum(:month) || 0) + 1
    payments.create(month: next_month, deliquency: deliquency, pay_all: pay_all)
  end

  def paid?
    (payments.count == duration) || payments.where(pay_all: true).exists?
  end

  def paid_perc
    normal_payments     = payments.where(deliquency: false).count
    deliquency_payments = payments.where(deliquency: true).count

    (monthly_perc_payment * normal_payments) + (monthly_deliquency_perc_payment * deliquency_payments)
  end

  def paid_debt
    if paid?
      amount
    else
      monthly_debt_payment * payments.count
    end
  end

  def result_rate
    return 0.0 if paid_debt.round(2).zero?
    (paid_perc / paid_debt) * (12.0 / duration)
  end

  # global stats
  class << self
    def calculated_rate
      loans = all.to_a
      loans.map(&:result_rate).inject(:+) / loans.count
    end

    def expected_rate
      BASE_ANNUAL_RATE
    end
  end

  # human readers
  percent_human_reader_for  :annual_rate, :deliquency_rate, :result_rate
  currency_human_reader_for :amount, :monthly_debt_payment, :monthly_perc_payment, :monthly_deliquency_perc_payment,
                            :monthly_payment, :monthly_deliquency_payment, :paid_debt, :paid_perc

  private

  def assign_defaults
    assign_attributes duration:         BASE_DURATION,
                      period:           BASE_PERIOD,
                      annual_rate:      BASE_ANNUAL_RATE,
                      deliquency_rate:  BASE_DELIQENCY_RATE
  end
end
