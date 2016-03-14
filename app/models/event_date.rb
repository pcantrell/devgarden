class EventDate < ApplicationRecord
  belongs_to :event, touch: true

  scope :future, -> do
    where('start_time >= ? or end_time >= ?', Time.now, Time.now)
      .order(:start_time)
      .includes(:event)
  end
end
