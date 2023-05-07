class Project < ApplicationRecord
  has_many :participations, -> { order(:id) }, dependent: :destroy
  has_many :participants, through: :participations, source: :person
  has_many :participant_invitations, dependent: :destroy

  has_many :role_requests, -> { includes(:role) }, dependent: :destroy
  has_many :requested_roles, through: :role_requests, source: :role
  
  has_many :project_tags, -> { includes(:tag).order(:order) }, dependent: :destroy
  has_many :tags, -> { includes(:category) }, through: :project_tags

  mount_uploader :icon, ProjectIconUploader

  MAX_TAGLINE_LENGTH = 50
  validates :name, presence: true
  validates :tagline, length: { maximum: MAX_TAGLINE_LENGTH }

  URL_REGEXP = /\A#{URI::regexp(%w(http https))}\Z/
  validates :url, format: URL_REGEXP, allow_blank: true
  validate :scm_urls_are_urls

  after_save :remove_duplicate_tags
  after_save :remove_duplicate_participants

  include OrderedDisplay
  include Themed
  include ConditionallyVisible
  include ChangeNotifying

  scope :with_scm_url, ->(scm_url) do
    where('scm_urls @> ARRAY[?::character varying]', scm_url)
  end

  def admins_include?(person)
    person && participations.where(person: person, admin: true).any?
  end

  def tags_grouped
    tags
      .visible
      .group_by(&:category)
      .sort_by(&:first)   # Sort groups in category order
  end

  include StringArrayAttribute
  exposes_array_as_text :scm_urls, from_text: ->(url) do
    url.gsub(GIT_REPO_FROM_URL, 'https://github.com/\1')
  end

  def github_repos
    scm_urls.map { |url| $1 if url =~ GIT_REPO_FROM_URL}.compact
  end

  def custom_notification_attributes
    {
      participations: participations.map { |p| p.person.name + (p.admin ? " [admin]" : "") },
      requested_roles: requested_roles.map(&:person_name),
      tags: tags.map(&:name),
    }
  end

private

  GIT_REPO_FROM_URL = %r{
      \A
      (?:
        # Several possible prefixes if user copied git URL instead of web URL
        git@github.com:
        | (?: https? | git )://github.com/
      )?
      (
        [\w-]+  # user name
        /
        [\w-]+  # project name
      )
      (\.git)?  # Drop .git suffix if present
      \Z
    }x

  def scm_urls_are_urls
    scm_urls.each do |url|
      unless url =~ URL_REGEXP
        msg = "<b>#{ERB::Util.h url}</b> is not a valid URL"
        errors.add(:scm_urls, msg)
        errors.add(:scm_urls_as_text, msg)
      end
    end
  end

  def remove_duplicate_tags
    self.project_tags = project_tags
      .sort_by(&:order)
      .uniq(&:tag_id)
  end

  def remove_duplicate_participants
    self.participations = participations
      .sort_by { |p| p.admin ? 0 : 1 }  # user is admin if any of their dup entries are
      .uniq(&:person_id)
  end

  def metadata_quality
    [
      (0.50 if icon.present?),
      (0.05 if tagline.present? || url.present?),
      (0.20 * [(description || '').length / 1000.0, 1.0].min),
      (0.25 if role_requests.any?)
    ].compact.sum
  end

end
