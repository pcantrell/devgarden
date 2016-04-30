class AddDisplayOrder < ActiveRecord::Migration[5.0]
  def change
    %i(projects people).each do |table|
      add_column table, :display_order, :bigint

      reversible do |dir|
        dir.up do
          execute "update #{table} set display_order = extract(epoch from updated_at) * 1000"
        end
      end

      change_column_null table, :display_order, false
    end
  end
end
