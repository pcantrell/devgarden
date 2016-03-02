class AddMessageToJobReports < ActiveRecord::Migration[5.0]
  def change
    add_column :job_reports, :message, :text
  end
end
