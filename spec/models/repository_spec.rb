require 'rails_helper'

RSpec.describe Repository, type: :model do
  it "generates a secret on creation" do
    repo = Repository.create!(github_id: 1)
    expect(repo.secret).not_to be_nil
  end
end
