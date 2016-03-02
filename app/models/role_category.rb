class RoleCategory < ApplicationRecord
  has_many :roles, foreign_key: :category_id
end
