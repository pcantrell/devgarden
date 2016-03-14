class RoleOffer < ApplicationRecord
  belongs_to :person, touch: true
  belongs_to :role, touch: true
end
