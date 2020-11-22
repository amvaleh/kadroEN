class RenameLocationTypeIdToShootLocationIdFromShootLocations < ActiveRecord::Migration[5.0]
  def change
    rename_column :shoot_locations, :location_type_id, :shoot_location_type_id
  end
end
