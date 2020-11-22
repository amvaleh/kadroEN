class CreateCartItems < ActiveRecord::Migration[5.0]
  def change
    create_table :cart_items do |t|
      t.integer :item_id
      t.integer :photo_id
      t.integer :project_id

      t.timestamps
    end
    add_foreign_key(:cart_items, :items, column: :item_id, index: true)
    add_foreign_key(:cart_items, :photos, column: :photo_id, index: true)
    add_foreign_key(:cart_items, :projects, column: :project_id, index: true)
  end
end
