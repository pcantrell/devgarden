class Person < ActiveRecord::Base
  has_many :participations
  has_many :projects, through: :participations
  has_many :role_offers, -> { includes(:role) }

  validates :name, :email, presence: true
  validates :class_year, inclusion: 1920..(Time.now.year + 4), allow_blank: true

  include RecentScope

  def name
    full_name || github_user
  end

  def student_or_alum?
    class_year?
  end

  def faculty_or_staff?
    department?
  end

  include StringArrayAttribute
  exposes_string_array_as_text :urls

  def self.for_auth(auth)
    provider, uid = auth["provider"], auth["uid"]
    raise "No credentials found" unless provider && uid
    external_id = "#{provider}:#{uid}"
    
    if provider == "github"
      info = auth["info"] || {}
      email       = info["email"]
      name        = info["name"]
      github_user = info["nickname"]
      avatar_url  = info["image"]
      urls        = info["urls"].values
    end

    user = Person.find_by('external_ids @> ARRAY[?]', external_id) ||
           (Person.find_by(github_user: github_user) if github_user) ||
           (Person.find_by(email: email) if email) ||
           Person.new
    user.full_name ||= name
    user.email ||= email
    user.external_ids = (user.external_ids + [external_id]).uniq
    user.avatar_url ||= avatar_url
    user.github_user ||= github_user
    user.urls = urls if user.urls.empty?
    user.save!
    user
  end
end
