class AddIsFirstOrderToCoupons < ActiveRecord::Migration[5.0]
  def change
    add_column :coupons, :is_first_order, :boolean, null: false, default: false
  end
end
