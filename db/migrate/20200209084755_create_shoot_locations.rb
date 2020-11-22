class CreateShootLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :shoot_locations do |t|
      t.integer :photographer_id
      t.integer :location_type_id
      t.float :latitude
      t.float :longitude
      t.string :input
      t.string :detail
      t.boolean :in_studio
      t.boolean :approved
      t.timestamps
    end
  end
end
