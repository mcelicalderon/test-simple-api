FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "Vincent#{n}" }
    sequence(:last_name)  { |n| "Vega#{n}" }
  end
end
