class AddAddressIdToShootLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_locations, :address_id, :integer
  end
end
