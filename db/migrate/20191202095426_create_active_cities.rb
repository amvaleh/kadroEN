class CreateActiveCities < ActiveRecord::Migration[5.0]
  def change
    add_column :cities, :latitude, :float
    add_column :cities, :longitude, :float
    create_view :active_cities
  end
end
