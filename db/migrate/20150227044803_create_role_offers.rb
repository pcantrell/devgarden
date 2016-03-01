class CreateRoleOffers < ActiveRecord::Migration[4.2]
  def change
    create_table :role_offers do |t|
      t.references :person, index: true
      t.references :role, index: true
      t.text :comment

      t.timestamps null: false
    end
    add_foreign_key :role_offers, :people
    add_foreign_key :role_offers, :roles
  end
end
