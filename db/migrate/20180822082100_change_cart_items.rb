class ChangeCartItems < ActiveRecord::Migration[5.0]
  def change
    rename_column(:cart_items, :photo_id, :frame_id)
    remove_foreign_key(:cart_items, :photos)
    add_foreign_key(:cart_items, :frames, column: :frame_id, index: true)
    add_column(:cart_items, :quantity, :integer)
  end
end
