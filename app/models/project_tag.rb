class ProjectTag < ApplicationRecord
  belongs_to :project, touch: true
  belongs_to :tag, touch: true
end
