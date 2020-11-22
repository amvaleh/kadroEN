class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :title
      t.float :price
      t.text :description
      t.integer :item_type_id

      t.timestamps
    end
  end
end
