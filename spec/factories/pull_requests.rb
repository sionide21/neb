FactoryGirl.define do
  factory :pull_request do
    repository
    sequence(:github_id)
    title "My Title"
    author "Some Guy"
  end
end
