FactoryGirl.define do
  factory :loan do
    legal_entity { FFaker::Company.name }
    amount { 1_000_000 + rand(1_000_000) }

    trait :paid do
      after :create do |loan|
        loan.duration.times { loan.add_next_payment! }
      end
    end
  end
end
