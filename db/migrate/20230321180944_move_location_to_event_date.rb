class MoveLocationToEventDate < ActiveRecord::Migration[7.0]
  def change
    add_reference :event_dates, :location, index: true, foreign_key: true
    reversible do |direction|
      direction.up do
        execute "update event_dates set location_id = (
          select location_id from events where events.id = event_id)"
      end
      direction.down do
        execute "update events set location_id = (
          select distinct event_dates.location_id from event_dates where event_id = events.id)"
      end
    end
    remove_reference :events, :location
  end
end
