class Payment < ApplicationRecord
  include HumanReaders

  belongs_to :loan

  validates :loan,
            :month, presence: true

  validates :month,
            inclusion:  { in: ->(payment) { (1..payment.loan.duration) } },
            uniqueness: { scope: :loan_id }

  def amount
    percents = deliquency? ? loan.monthly_deliquency_perc_payment : loan.monthly_perc_payment

    monthly_debt_payment = loan.monthly_debt_payment
    debt = if pay_all?
             loan.amount - loan.payments.where(pay_all: false).count * monthly_debt_payment
           else
             loan.monthly_debt_payment
           end

    debt + percents
  end

  currency_human_reader_for :amount
end
