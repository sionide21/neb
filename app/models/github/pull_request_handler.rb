module Github
  class PullRequestHandler < EventHandler
    def handle
      return unless repository
      return unless respond_to?(action)
      return unless action == "opened" || pull_request

      public_send(action)
    end

    def opened
      return if pull_request

      repository.pull_requests.create!(
        github_id: payload.pull_request.id,
        link: payload.pull_request.html_url,
        title: payload.pull_request.title,
        author: payload.pull_request.user.login,
        state: payload.pull_request.state
      )
    end

    def closed
      pull_request.update!(state: payload.pull_request.state)
    end

    def labeled
      pull_request.labels << payload.label.name
      pull_request.save!
    end

    def unlabeled
      pull_request.labels.delete(payload.label.name)
      pull_request.save!
    end

    private

    def pull_request
      @pull_request ||= repository.pull_requests.find_by(github_id: payload.pull_request.id)
    end

    def action
      payload.action
    end
  end
end
