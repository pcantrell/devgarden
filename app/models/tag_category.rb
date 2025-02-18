class TagCategory < ApplicationRecord
  has_many :tags, foreign_key: :category_id

  scope :in_order, -> { order(:order) }

  def find_or_create_tag!(name)
    # Find any existing tag with the given name, even if it’s in a different category
    Tag.find_by("lower(name) IN (?)", name.downcase) ||
      Tag.find_by("lower(short_name) IN (?)", name.downcase) ||
      tags.create!(name: name)
  end
end
