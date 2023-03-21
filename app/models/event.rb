class Event < ApplicationRecord
  has_many :dates, class_name: "EventDate", dependent: :destroy

  validates :title, presence: true

  include ConditionallyVisible
  include ChangeNotifying

  def custom_notification_attributes
    {
      dates: dates.map { |d| [d.start_time, d.end_time, d.location&.name] }
    }
  end
end
