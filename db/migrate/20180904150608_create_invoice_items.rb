class CreateInvoiceItems < ActiveRecord::Migration[5.0]
  def change
    create_table :invoice_items do |t|
      t.integer :invoice_id
      t.integer :cart_item_id
      t.float :unit_price
      t.float :price
      t.integer :quantity

      t.timestamps
    end
    add_foreign_key(:invoice_items, :invoices, column: :invoice_id, index: true)
    add_foreign_key(:invoice_items, :cart_items, column: :cart_item_id, index: true)
  end
end
