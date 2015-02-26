class Project < ActiveRecord::Base
  has_many :participations
  has_many :participants, through: :participations, source: :person
end
