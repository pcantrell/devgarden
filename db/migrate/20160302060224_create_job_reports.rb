class CreateJobReports < ActiveRecord::Migration[5.0]
  def change
    create_table :job_reports do |t|
      t.references :owner
      t.json :results
      t.json :error

      t.timestamp :completed_at
      t.timestamps
    end
    add_foreign_key :job_reports, :people, column: "owner_id"
  end
end
