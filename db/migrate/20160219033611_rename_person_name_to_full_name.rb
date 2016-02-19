class RenamePersonNameToFullName < ActiveRecord::Migration
  def change
    rename_column :people, :name, :full_name
  end
end
