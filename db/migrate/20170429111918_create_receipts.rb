class CreateReceipts < ActiveRecord::Migration[5.0]
  def change
    create_table :receipts do |t|
      t.string :total
      t.string :subtotal
      t.integer :coupon_id
      t.integer :user_id

      t.timestamps
    end
  end
end
