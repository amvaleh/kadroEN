class AddActiveToShootTypeLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_type_locations, :active, :boolean , default: true
  end
end
