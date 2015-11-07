require 'hash_struct'

module Github
  class EventHandler
    BadSignature = Class.new(StandardError)

    def self.for_event(event)
      {
        "pull_request" => PullRequestHandler
      }.fetch(event, Github::NullHandler)
    end

    def self.handle_payload(*args)
      new(*args).handle
    end

    def initialize(payload, signature:)
      @payload = HashStruct.new(JSON.parse(payload))
      verify_signature!(payload, signature: signature)
    end

    def handle
    end

    private

    def verify_signature!(payload, signature:)
      raise BadSignature.new unless repository && repository.sign(payload) == signature
    end

    def repository
    end

    attr_reader :payload
  end
end
