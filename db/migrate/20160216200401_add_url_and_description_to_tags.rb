class AddUrlAndDescriptionToTags < ActiveRecord::Migration[4.2]
  def change
    add_column :tags, :url, :string
    add_column :tags, :description, :text
  end
end
