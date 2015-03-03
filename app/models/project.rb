class Project < ActiveRecord::Base
  has_many :participations
  has_many :participants, through: :participations, source: :person
  has_many :role_requests

  validates :name, presence: true

  include RecentScope
end
