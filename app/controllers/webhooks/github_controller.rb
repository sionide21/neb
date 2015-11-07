class Webhooks::GithubController < Webhooks::BaseController
  def receive
    handler.handle_payload(JSON.parse(request.raw_post))
    render text: "ok"
  end

  private

  def handler
    Github::EventHandler.for_event(request.headers["X-Github-Event"])
  end
end
