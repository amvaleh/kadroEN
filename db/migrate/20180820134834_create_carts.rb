class CreateCarts < ActiveRecord::Migration[5.0]
  def change
    create_table :carts do |t|
      t.integer :cart_item_id
      t.integer :user_id
      t.datetime :date_time

      t.timestamps
    end
    add_foreign_key(:carts, :cart_items, column: :cart_item_id, index: true)
    add_foreign_key(:carts, :users, column: :user_id, index: true)
  end
end
