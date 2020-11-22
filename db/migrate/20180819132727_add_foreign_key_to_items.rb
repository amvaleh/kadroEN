class AddForeignKeyToItems < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key(:items, :item_types, column: :item_type_id, index: true)
  end
end
