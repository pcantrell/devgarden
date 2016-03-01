class CreateRoleRequests < ActiveRecord::Migration[4.2]
  def change
    create_table :role_requests do |t|
      t.references :project, index: true
      t.references :role, index: true
      t.integer :priority
      t.text :comment

      t.timestamps null: false
    end
    add_foreign_key :role_requests, :projects
    add_foreign_key :role_requests, :roles
  end
end
