FactoryGirl.define do
  factory :payment do
    loan { create :loan }
    month 1
    deliquency false
  end
end
