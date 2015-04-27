class Project < ActiveRecord::Base
  has_many :participations
  has_many :participants, through: :participations, source: :person
  has_many :role_requests

  validates :name, presence: true

  URL_REGEXP = URI::regexp(%w(http https))
  validates :url, format: URL_REGEXP, allow_blank: true
  validate :scm_urls_are_urls

  include RecentScope

  def scm_urls_as_text
    scm_urls.join("\n")
  end

  def scm_urls_as_text=(text)
    self.scm_urls = text.split(/\s+/).reject(&:blank?)
  end

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
