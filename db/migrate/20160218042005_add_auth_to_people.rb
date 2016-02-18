class AddAuthToPeople < ActiveRecord::Migration
  def change
    add_column :people, :external_ids, :text, array: true, null: false, default: []
    add_index :people, :external_ids, using: :gin

    add_column :people, :github_user, :string
    add_index :people, :github_user

    add_column :people, :avatar_url, :string

    add_column :people, :urls, :string, array: true, null: false, default: []
    remove_column :people, :url, :string
  end
end
