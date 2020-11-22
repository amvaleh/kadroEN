class CreateShopOrderDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :shop_order_details do |t|
      t.integer :photographer_id
      t.integer :invoice_item_id
      t.float :subtotal

      t.timestamps
    end
  end
end
