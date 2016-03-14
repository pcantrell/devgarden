class Participation < ApplicationRecord
  belongs_to :project, touch: true
  belongs_to :person, touch: true
end
