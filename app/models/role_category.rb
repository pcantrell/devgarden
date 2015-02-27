class RoleCategory < ActiveRecord::Base
  has_many :roles, foreign_key: :category_id
end
