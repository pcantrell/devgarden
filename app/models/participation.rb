class Participation < ApplicationRecord
  belongs_to :project, touch: true
  belongs_to :person, touch: true

  scope :with_visible_project, -> do
    includes(:project).where(projects: { visible: true })
  end

  scope :with_visible_person, -> do
    includes(:person).where(people: { visible: true })
  end
end
