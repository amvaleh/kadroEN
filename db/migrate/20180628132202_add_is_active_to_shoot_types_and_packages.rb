class AddIsActiveToShootTypesAndPackages < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_types, :is_active, :boolean , default: true , null: false
    add_column :packages, :is_active, :boolean , default: true , null: false
  end
end
