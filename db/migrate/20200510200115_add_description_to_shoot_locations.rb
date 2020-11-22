class AddDescriptionToShootLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_locations, :description, :text
  end
end
