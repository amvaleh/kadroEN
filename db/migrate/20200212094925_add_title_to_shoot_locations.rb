class AddTitleToShootLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_locations, :title, :string
  end
end
