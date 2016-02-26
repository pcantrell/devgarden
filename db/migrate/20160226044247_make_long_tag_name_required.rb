class MakeLongTagNameRequired < ActiveRecord::Migration
  def change
    rename_column :tags, :long_name, :short_name  # cheat is OK because no prod data yet
  end
end
