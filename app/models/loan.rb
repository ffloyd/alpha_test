class Loan < ApplicationRecord
  BASE_DURATION       = 6
  BASE_PERIOD         = 1 # TODO: currently ignored in formulas
  BASE_ANNUAL_RATE    = 0.3
  BASE_DELIQENCY_RATE = 0.5

  validates :legal_entity,
            :amount,
            :period,
            :duration,
            :annual_rate,
            :deliquency_rate, presence: true

  after_initialize :assign_defaults

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

  private

  def assign_defaults
    assign_attributes duration:         BASE_DURATION,
                      period:           BASE_PERIOD,
                      annual_rate:      BASE_ANNUAL_RATE,
                      deliquency_rate:  BASE_DELIQENCY_RATE
  end
end
