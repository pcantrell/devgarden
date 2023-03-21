class EventDate < ApplicationRecord
  belongs_to :event, touch: true
  belongs_to :location

  scope :future, -> do
    where('start_time >= ? or end_time >= ?', Time.now, Time.now)
      .order(:start_time)
      .includes(:event, :location)
      .where(events: { visible: true })
  end
end
