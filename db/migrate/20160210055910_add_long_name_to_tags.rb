class AddLongNameToTags < ActiveRecord::Migration[4.2]
  def change
    add_column :tags, :long_name, :string
  end
end
