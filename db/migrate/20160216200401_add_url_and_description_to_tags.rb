class AddUrlAndDescriptionToTags < ActiveRecord::Migration
  def change
    add_column :tags, :url, :string
    add_column :tags, :description, :text
  end
end
