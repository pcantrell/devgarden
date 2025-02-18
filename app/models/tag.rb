class Tag < ApplicationRecord
  belongs_to :category, class_name: "TagCategory"
  has_many :project_tags
  has_many :projects, -> { order('projects.updated_at desc') }, through: :project_tags

  validates :name, presence: true, uniqueness: {
    case_sensitive: false,
    message: "“%{value}” is already used by a tag"
  }
  validates :category, presence: true

  include ConditionallyVisible
  include ChangeNotifying
end
