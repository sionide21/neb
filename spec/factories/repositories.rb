FactoryGirl.define do
  factory :repository do
    sequence(:github_id)
    name "A Repository"
  end
end
