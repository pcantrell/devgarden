class FixAssociationNotNullConstraints < ActiveRecord::Migration[4.2]
  def change
    change_column_null :participations, :project_id, false
    change_column_null :participations, :person_id, false

    change_column_null :role_offers, :person_id, false
    change_column_null :role_offers, :role_id, false

    change_column_null :role_requests, :project_id, false
    change_column_null :role_requests, :role_id, false

    change_column_null :roles, :category_id, false
  end
end
