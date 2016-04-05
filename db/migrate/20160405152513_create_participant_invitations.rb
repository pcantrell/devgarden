class CreateParticipantInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :participant_invitations do |t|
      t.text :invitation_code, null: false
      t.references :project, index: true
      
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :admin, null: false, default: false
      t.integer :order

      t.references :created_by, index: true
      t.timestamps
    end
    add_foreign_key :participant_invitations, :projects
    add_foreign_key :participant_invitations, :people, column: :created_by_id
  end
end
