FactoryGirl.define do
  factory :loan do
    legal_entity { FFaker::Company.name }
    amount { 1_000_000 + rand(1_000_000) }
  end
end
