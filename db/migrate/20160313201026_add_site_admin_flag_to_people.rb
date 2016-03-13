class AddSiteAdminFlagToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :site_admin, :boolean, null: false, default: false
    execute "update people set site_admin = true where github_user = 'pcantrell'"
  end
end
