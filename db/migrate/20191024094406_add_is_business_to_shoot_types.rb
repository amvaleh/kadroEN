class AddIsBusinessToShootTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_types, :is_business, :boolean , default: false
  end
end
