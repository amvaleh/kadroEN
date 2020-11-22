class AddOrderToShootTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_types, :order, :integer
  end
end
