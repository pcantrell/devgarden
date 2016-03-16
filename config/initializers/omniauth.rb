Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,
    ENV['DEV_GARDEN_GITHUB_CLIENT_ID'],
    ENV['DEV_GARDEN_GITHUB_SECRET'],
    scope: "user:email,admin:repo_hook"
end
