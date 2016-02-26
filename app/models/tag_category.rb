class TagCategory < ActiveRecord::Base
  has_many :tags, foreign_key: :category_id

  scope :in_order, -> { order(:order) }
end
