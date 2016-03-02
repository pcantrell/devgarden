class Participation < ApplicationRecord
  belongs_to :project
  belongs_to :person
end
