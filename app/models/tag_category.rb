class TagCategory < ApplicationRecord
  has_many :tags, foreign_key: :category_id

  scope :in_order, -> { order(:order) }

  def find_or_create_tag!(name)
    tags.find_by("lower(name) IN (?)", name.downcase) ||
      tags.find_by("lower(short_name) IN (?)", name.downcase) ||
      tags.create!(name: name)
  end
end
