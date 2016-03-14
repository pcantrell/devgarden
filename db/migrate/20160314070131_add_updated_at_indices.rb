class AddUpdatedAtIndices < ActiveRecord::Migration[5.0]
  def change
    %i(people projects events).each do |table|
      add_index table, :updated_at
    end
  end
end
