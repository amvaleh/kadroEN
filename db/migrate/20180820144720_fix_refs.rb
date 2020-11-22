class FixRefs < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key(:carts, :cart_items)
    add_column(:cart_items, :cart_id, :integer)
    remove_column(:carts, :cart_item_id)
    add_foreign_key(:cart_items, :carts, column: :cart_id, index: true)
  end
end
