class Role < ActiveRecord::Base
  belongs_to :category, class_name: 'RoleCategory'
end
