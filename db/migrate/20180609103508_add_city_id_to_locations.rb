class AddCityIdToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :city_id, :integer
  end
end
