class Tag < ActiveRecord::Base
  belongs_to :category, class: TagCategory
end
