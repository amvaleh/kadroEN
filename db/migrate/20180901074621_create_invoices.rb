class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.string :vch_number
      t.integer :cart_id
      t.integer :coupon_id
      t.integer :address_id

      t.timestamps
    end
    add_foreign_key(:invoices, :carts, column: :cart_id, index: true)
    add_foreign_key(:invoices, :coupons, column: :coupon_id, index: true)
    add_foreign_key(:invoices, :addresses, column: :address_id, index: true)
  end
end
