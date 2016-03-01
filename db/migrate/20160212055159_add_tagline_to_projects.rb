class AddTaglineToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :tagline, :string
  end
end
