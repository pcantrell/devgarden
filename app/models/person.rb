class Person < ActiveRecord::Base
  has_many :participations
  has_many :projects, through: :participations
  has_many :role_offers
end
