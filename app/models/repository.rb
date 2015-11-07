class Repository < ActiveRecord::Base
  before_create :generate_secret
  has_many :pull_requests

  def sign(payload)
    digest = OpenSSL::Digest.new('sha1')
    "sha1=#{OpenSSL::HMAC.hexdigest(digest, secret, payload)}"
  end

  private

  def generate_secret
    self.secret = SecureRandom.hex(20)
  end
end
