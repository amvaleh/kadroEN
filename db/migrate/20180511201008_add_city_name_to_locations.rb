class AddCityNameToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :city_name, :string , default: " "
  end
end
