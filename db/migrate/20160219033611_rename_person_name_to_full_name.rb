class RenamePersonNameToFullName < ActiveRecord::Migration[4.2]
  def change
    rename_column :people, :name, :full_name
  end
end
