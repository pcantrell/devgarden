class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :detail

      t.timestamps null: false
    end

    create_table :events do |t|
      t.string :title, null: false
      t.text :description
      t.references :location, index: true

      t.timestamps null: false
    end
    add_foreign_key :events, :locations

    create_table :event_dates do |t|
      t.references :event, null: false, index: true
      t.datetime :start_time, null: false
      t.datetime :end_time

      t.timestamps null: false
    end
    add_foreign_key :event_dates, :events
  end
end
