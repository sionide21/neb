require 'rails_helper'

RSpec.describe PullRequest, type: :model do
  let(:pull_request) { FactoryGirl.create(:pull_request) }

  it "doesn't duplicate labels" do
    pull_request.update!(labels: ["hello"])
    pull_request.labels += ["world", "hello"]
    pull_request.save!

    expect(pull_request.labels).to eq(["hello", "world"])
  end
end
