class Event < ApplicationRecord
  belongs_to :location
  has_many :dates, class_name: "EventDate", dependent: :destroy

  validates :title, presence: true

  include ConditionallyVisible
  include ChangeNotifying

  def custom_notification_attributes
    {
      location: location.name,
      dates: dates.map { |d| [d.start_time, d.end_time] },
    }
  end
end
