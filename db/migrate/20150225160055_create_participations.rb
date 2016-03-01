class CreateParticipations < ActiveRecord::Migration[4.2]
  def change
    create_table :participations do |t|
      t.references :project, index: true
      t.references :person, index: true
      t.boolean :admin, null: false, default: false

      t.timestamps null: false
    end
    add_foreign_key :participations, :projects
    add_foreign_key :participations, :people
  end
end
