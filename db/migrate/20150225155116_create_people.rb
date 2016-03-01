class CreatePeople < ActiveRecord::Migration[4.2]
  def change
    create_table :people do |t|
      t.string :name
      t.string :email
      t.string :url

      t.timestamps null: false
    end

    add_index :people, :email, unique: true
  end
end
