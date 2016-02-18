Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,
    ENV['GITHUB_CLIENT_ID'],
    ENV['GITHUB_SECRET'],
    scope: "user:email,admin:repo_hook"
end
