class Person < ActiveRecord::Base
  has_many :participations
  has_many :projects, through: :participations
  has_many :role_offers, -> { includes(:role) }

  include RecentScope

  def self.for_auth(auth)
    provider, uid = auth["provider"], auth["uid"]
    raise "No credentials found" unless provider && uid
    external_id = "#{provider}:#{uid}"
    
    info = auth["info"] || {}
    email = info["email"]
    name  = info["name"]

    user = Person.find_by('external_ids @> ARRAY[?]', external_id) ||
           (Person.find_by(email: email) if email) ||
           Person.new(external_ids: [external_id], name: name, email: email)
    user.external_ids = (user.external_ids + [external_id]).uniq
    user.avatar_url ||= info["image"]
    user.github_user ||= info["nickname"]
    user.urls = info["urls"].values if user.urls.empty?
    user.save!
    user
  end
end
