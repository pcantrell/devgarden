class AddIconToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :icon, :string
  end
end
