FactoryGirl.define do
  factory :event do
    start_date Date.today
    end_date 10.days.from_now
    sequence(:name) { |n| "Event:#{n}" }
    description 'Some long event description with encoded format'
    state 'draft'
    user
    location
  end
end
