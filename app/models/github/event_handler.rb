require 'hash_struct'

module Github
  class EventHandler
    def self.for_event(event)
      {
        "pull_request" => PullRequestHandler
      }.fetch(event, Github::NullHandler)
    end

    def self.handle_payload(payload)
      new(payload).handle
    end

    def initialize(payload)
      @payload = HashStruct.new(payload)
    end

    def handle
    end

    private

    attr_reader :payload
  end
end
