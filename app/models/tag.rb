class Tag < ActiveRecord::Base
  belongs_to :category, class: TagCategory
  has_many :project_tags
  has_many :projects, -> { order('projects.updated_at') }, through: :project_tags

  def full_name
    long_name || name
  end
end
