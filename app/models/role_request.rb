class RoleRequest < ApplicationRecord
  belongs_to :project, touch: true
  belongs_to :role, touch: true
end
