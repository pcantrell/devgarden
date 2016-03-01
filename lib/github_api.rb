module GithubAPI
  def self.client
    Octokit::Client.new(
      client_id:     ENV['GITHUB_CLIENT_ID'],
      client_secret: ENV['GITHUB_SECRET'])
  end
end
