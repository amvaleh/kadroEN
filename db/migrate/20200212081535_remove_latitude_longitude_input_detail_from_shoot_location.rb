class RemoveLatitudeLongitudeInputDetailFromShootLocation < ActiveRecord::Migration[5.0]
  def change
    remove_column :shoot_locations, :latitude
    remove_column :shoot_locations, :longitude
    remove_column :shoot_locations, :input
    remove_column :shoot_locations, :detail
  end
end
