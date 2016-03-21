class AddLastLoginDateToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :last_login_at, :timestamp
  end
end
