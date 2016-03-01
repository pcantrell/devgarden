class CreateTags < ActiveRecord::Migration[4.2]
  def change
    create_table :tag_categories do |t|
      t.string :key, null: false
      t.string :name, null: false
      t.integer :order
      t.timestamps null: false
    end

    create_table :tags do |t|
      t.string :name, null: false, index: true
      t.references :category, references: :tag_categories, null: false, index: true
      t.timestamps null: false
    end
    add_foreign_key :tags, :tag_categories, column: :category_id

    create_table :project_tags do |t|
      t.references :project, null: false, index: true
      t.references :tag, null: false, index: true
      t.integer :order
      t.timestamps null: false
    end
    add_foreign_key :project_tags, :projects
    add_foreign_key :project_tags, :tags
  end
end
