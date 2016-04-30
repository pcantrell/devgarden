class Person < ApplicationRecord
  has_many :participations, dependent: :destroy
  has_many :projects, through: :participations
  has_many :role_offers, -> { includes(:role) }, dependent: :destroy
  has_many :offered_roles, through: :role_offers, source: :role
  has_many :participant_invitations, foreign_key: :created_by_id, dependent: :destroy

  validates :class_year, inclusion: 1920..(Time.now.year + 4), allow_blank: true

  include OrderedDisplay
  include Themed
  include ConditionallyVisible
  include ChangeNotifying

  scope :name_search, ->(name) do
    if name.blank?
      none
    else
      ransack(full_name_or_github_user_cont: name).result
    end
  end

  def self.find_by_github_user(login)
    find_case_insensitive_if_present(:github_user, login)
  end

  def self.find_by_email(email)
    find_case_insensitive_if_present(:email, email)
  end

  def name
    full_name.presence || github_user.presence || "[anonymous:#{id}]"
  end

  def short_name
    github_user.presence || name.split.first
  end

  def newly_created?
    @newly_created
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

  %w(email github_user).each do |lowercase_prop|
    define_method "#{lowercase_prop}=" do |val|
      super(val&.downcase)
    end
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
           (Person.find_by_github_user(github_user)) ||
           (Person.find_by_email(email)) ||
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

  def logged_in!
    @newly_created = last_login_at.blank?

    # update_columns so we don't change updated_at
    update_columns(last_login_at: Time.now)
  end

  def custom_notification_attributes
    {
      projects: projects.map(&:name),
      role_offers: offered_roles.map(&:skill_name),
    }
  end

private

  def self.find_case_insensitive_if_present(key, value)
    return nil if value.blank?
    find_by(key => value.downcase)
  end

  def metadata_quality
    [
      (0.3 if full_name.present?),
      (0.7 if role_offers.any?)
    ].compact.sum
  end

end
