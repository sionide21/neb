class Webhooks::GithubController < Webhooks::BaseController


  def receive
    handler.handle_payload(request.raw_post, signature: signature)
    render text: "ok"
  rescue Github::EventHandler::BadSignature
    render text: "bad signature", status: 401
  end

  private

  def handler
    Github::EventHandler.for_event(request.headers["X-Github-Event"])
  end

  def signature
    request.headers["X-Hub-Signature"]
  end
end
