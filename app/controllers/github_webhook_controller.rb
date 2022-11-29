class GithubWebhookController < ApplicationController
  # Disable CSRF verification for the endpoint GitHub uses
  skip_before_action :verify_authenticity_token, only: [:receive]

  def receive
    # Ignore all but `push` events
    unless request.headers["X-GitHub-Event"] == "push"
      # GitHub Docs advise returning 200 if the webhook was delivered, even if you don't want it
      render body: nil
      return
    end

    # Verify message
    hash = OpenSSL::HMAC.hexdigest("SHA256", ENV['GITHUB_WEBHOOK_SECRET'], request.raw_post)
    unless request.headers["X-Hub-Signature-256"] == "sha256=#{hash}" # Signatures are in the format `sha256=HASH`
      render body: nil, status: :unauthorized
      return
    end

    # Find project
    repository_url = params[:repository][:url]
    project = Project.where("? = ANY(scm_urls)", repository_url)

    if project != nil
      # Update `display_order` with latest commit's timestamp
      project.update(display_order: params[:repository][:pushed_at].to_i * 1000)
    else
      logger.warn "Repository #{repository_url} does not exist"
    end

    render body: nil
  end
end