class Project < ActiveRecord::Base
  has_many :participations
  has_many :participants, through: :participations, source: :person
  has_many :role_requests, -> { includes(:role) }
  has_many :project_tags, -> { includes(:tag).order(:order) }
  has_many :tags, -> { includes(:category) }, through: :project_tags

  mount_uploader :icon, ProjectIconUploader

  validates :name, presence: true
  validates :tagline, length: { maximum: 50 }

  URL_REGEXP = URI::regexp(%w(http https))
  validates :url, format: URL_REGEXP, allow_blank: true
  validate :scm_urls_are_urls

  include RecentScope

  def admins_include?(person)
    participations.where(person: person, admin: true).any?
  end

  def tags_grouped
    tags
      .group_by(&:category)
      .sort_by(&:first)
  end

  include StringArrayAttribute
  exposes_string_array_as_text :scm_urls

private

  def scm_urls_are_urls
    scm_urls.each do |url|
      unless url =~ URL_REGEXP
        msg = "<b>#{ERB::Util.h url}</b> is not a valid URL"
        errors.add(:scm_urls, msg)
        errors.add(:scm_urls_as_text, msg)
      end
    end
  end
end
