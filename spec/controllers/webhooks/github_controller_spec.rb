require 'rails_helper'

RSpec.describe Webhooks::GithubController, type: :request do
  let!(:repo) { FactoryGirl.create(:repository, github_id: 45738800) }

  def send_payload_fixture(payload_name, **opts)
    payload = File.read("spec/fixtures/webhooks/#{payload_name}.json")
    send_payload(payload, **opts)
  end

  def send_payload(payload, type:)
    post "/webhooks/github", payload, {
      "Content-Type" => "application/json",
      "X-Github-Event" => type
    }
  end

  it "handles unknown event types" do
    send_payload_fixture "open_pull_request", type: "bananas"
    expect(response).to be_success
  end

  context "when a pull request is opened" do
    it "adds the PR to the repo" do
      expect {
        send_payload_fixture "open_pull_request", type: "pull_request"
        expect(response).to be_success
      }.to change { repo.pull_requests.count }.by(1)
    end

    it "is idempotent" do
      expect {
        send_payload_fixture "open_pull_request", type: "pull_request"
        expect(response).to be_success

        send_payload_fixture "open_pull_request", type: "pull_request"
        expect(response).to be_success
      }.to change { repo.pull_requests.count }.by(1)
    end

    it "ignores missing repositories" do
      repo.update!(github_id: 1)
      expect {
        send_payload_fixture "open_pull_request", type: "pull_request"
        expect(response).to be_success
      }.not_to change { PullRequest.count }
    end
  end

  context "with an existing pull request" do
    let!(:pull_request) { FactoryGirl.create(:pull_request, repository: repo, github_id: 50036803) }

    it "handles unknown actions" do
      send_payload '{"action": "fire_ze_lazers", "repository": {"id": 45738800}}', type: "pull_request"
      expect(response).to be_success
    end

    it "ignores missing pull requests" do
      pull_request.update!(github_id: 1)
      send_payload_fixture "close_pull_request", type: "pull_request"
      expect(response).to be_success
    end

    context "when a label is added" do
      it "adds it to the list of labels" do
        expect {
          send_payload_fixture "label_pull_request", type: "pull_request"
          expect(response).to be_success
        }.to change { pull_request.reload.labels }.to include("enhancement")
      end
    end

    context "when a label is removed" do
      before(:each) do
        pull_request.update!(labels: ["enhancement"])
      end

      it "takes it off the list of labels" do
        expect {
          send_payload_fixture "unlabel_pull_request", type: "pull_request"
          expect(response).to be_success
        }.to change { pull_request.reload.labels }.to([])
      end
    end

    context "when the PR is closed" do
      it "updates the state" do
        expect {
          send_payload_fixture "close_pull_request", type: "pull_request"
          expect(response).to be_success
        }.to change { pull_request.reload.state }.to("closed")
      end
    end
  end
end
