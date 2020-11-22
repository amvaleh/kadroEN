class ChangeWorkinLatAndLongToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :locations, :working_lat, 'float USING CAST(working_lat AS float)'
    change_column :locations, :working_long, 'float USING CAST(working_long AS float)'
    change_column :locations, :living_lat, 'float USING CAST(living_lat AS float)'
    change_column :locations, :living_long, 'float USING CAST(living_long AS float)'
  end
end
