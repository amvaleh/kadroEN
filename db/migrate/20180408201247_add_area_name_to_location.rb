class AddAreaNameToLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :area_name, :string
  end
end
