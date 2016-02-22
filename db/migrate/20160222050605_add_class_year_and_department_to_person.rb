class AddClassYearAndDepartmentToPerson < ActiveRecord::Migration
  def change
    add_column :people, :class_year, :integer, index: true
    add_column :people, :department, :string
  end
end
