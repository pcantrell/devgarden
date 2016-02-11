class AddLongNameToTags < ActiveRecord::Migration
  def change
    add_column :tags, :long_name, :string
  end
end
