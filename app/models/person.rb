class Person < ApplicationRecord
  has_many :participations, dependent: :destroy
  has_many :projects, through: :participations
  has_many :role_offers, -> { includes(:role) }, dependent: :destroy
  has_many :offered_roles, through: :role_offers, source: :role

  validates :name, presence: true
  validates :class_year, inclusion: 1920..(Time.now.year + 4), allow_blank: true

  include RecentScope
  include Themed

  scope :name_search, ->(name) do
    if name.blank?
      none
    else
      ransack(full_name_or_github_user_cont: name).result
    end
  end

  def self.find_by_if_not_nil(keys)
    return nil if keys.values.any?(&:nil?)
    find_by(keys)
  end

  def name
    full_name || github_user || "[anonymous]"
  end

  def short_name
    github_user || name.split.first
  end

  def student_or_alum?
    class_year?
  end

  def faculty_or_staff?
    department?
  end

  def owned_projects
    projects.where('participations.admin' => true)
  end

  include StringArrayAttribute
  exposes_array_as_text :urls

  def self.for_auth(auth)
    provider, uid = auth.provider, auth.uid
    raise "No credentials found" unless provider && uid
    external_id = "#{provider}:#{uid}"
    
    if provider == "github"
      info = auth.info || {}
      email       = info.email
      name        = info.name
      github_user = info.nickname
      avatar_url  = info.image
      urls        = info.urls.values
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
