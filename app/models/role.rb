class Role < ApplicationRecord
  belongs_to :category, class_name: 'RoleCategory'
  has_many :role_requests
  has_many :role_offers
end
