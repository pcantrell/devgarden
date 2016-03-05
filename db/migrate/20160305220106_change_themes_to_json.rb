class ChangeThemesToJson < ActiveRecord::Migration[5.0]
  def change
    %i(projects people).each do |table|
      remove_column table, :theme_hue
      add_column table, :theme, :json, null: false, default: {}
    end
  end
end
