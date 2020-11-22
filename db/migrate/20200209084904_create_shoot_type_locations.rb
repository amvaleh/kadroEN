class CreateShootTypeLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :shoot_type_locations do |t|
      t.integer :shoot_location_id
      t.integer :shoot_type_id
      t.timestamps
    end
  end
end
