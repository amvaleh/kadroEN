class AddCityIdToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :city_id, :integer
  end
end
