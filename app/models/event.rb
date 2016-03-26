class Event < ApplicationRecord
  belongs_to :location
  has_many :dates, class_name: "EventDate", dependent: :destroy

  validates :title, presence: true

  include ConditionallyVisible
end
