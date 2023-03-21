class AddLocationUrl < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :url, :string
  end
end
