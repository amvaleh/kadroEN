class RenameLocationTypesToShootLocationTypes < ActiveRecord::Migration[5.0]
  def change
    rename_table :location_types, :shoot_location_types
  end
end
