class AddThemeHueToProjectsAndPeople < ActiveRecord::Migration[4.2]
  def change
    [:projects, :people].each do |table|
      add_column table, :theme_hue, :float
    end
  end
end
