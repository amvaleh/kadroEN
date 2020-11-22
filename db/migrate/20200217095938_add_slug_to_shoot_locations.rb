class AddSlugToShootLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_locations, :slug, :string
  end
end
