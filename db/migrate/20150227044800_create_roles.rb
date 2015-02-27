class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :skill_name
      t.string :person_name
      t.text :responsibilities
      t.references :category, references: :role_categories, index: true

      t.timestamps null: false
    end
    add_foreign_key :roles, :role_categories, column: :category_id
  end
end
