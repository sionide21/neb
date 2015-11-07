class Repository < ActiveRecord::Base
  before_create :generate_secret
  has_many :pull_requests

  private

  def generate_secret
    self.secret = SecureRandom.hex(20)
  end
end
