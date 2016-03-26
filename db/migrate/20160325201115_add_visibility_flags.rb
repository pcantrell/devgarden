class AddVisibilityFlags < ActiveRecord::Migration[5.0]
  def change
    %i(people projects tags events).each do |table|
      add_column table, :visible, :boolean, null: false, default: true
    end
  end
end
