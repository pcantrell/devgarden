class EventDate < ActiveRecord::Base
  belongs_to :event

  scope :future, -> do
    where('start_time >= ? or end_time >= ?', Time.now, Time.now)
      .order(:start_time)
      .includes(:event)
  end
end
