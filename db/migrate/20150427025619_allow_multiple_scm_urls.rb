class AllowMultipleScmUrls < ActiveRecord::Migration
  def up
    remove_column :projects, :scm_url
    add_column :projects, :scm_urls, :string, array: true, default: []
  end

  def down
    remove_column :projects, :scm_urls
    add_column :projects, :scm_url, :string
  end
end
