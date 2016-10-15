FactoryGirl.define do
  factory :loan do
    legal_entity { FFaker::Company.name }
    amount { 1_000_000 + rand(1_000_000) }

    trait :paid do
      transient do
        deliquencies_count 0
      end

      after :create do |loan, evaluator|
        normal_payments     = loan.duration - evaluator.deliquencies_count
        deliquency_payments = evaluator.deliquencies_count

        normal_payments.times { loan.add_next_payment! }
        deliquency_payments.times { loan.add_next_payment!(deliquency: true) }
      end
    end
  end
end
