class CreateRoleCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :role_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
