class Payment < ApplicationRecord
  belongs_to :loan

  validates :loan,
            :month, presence: true

  validates :month,
            inclusion:  { in: ->(payment) { (1..payment.loan.duration) } },
            uniqueness: { scope: :loan_id }
end
