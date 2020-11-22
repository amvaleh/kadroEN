class CreateEquipment < ActiveRecord::Migration[5.0]

  def change
    create_table :equipment do |t|
      t.integer :photographer_id
      t.integer :camera_id
      t.integer :lenz_id
      t.boolean :small_product_kit
      t.boolean :large_product_kit
      t.boolean :portable_light
      t.integer :light_studio_kit
      t.boolean :portable_studio_kit

      t.timestamps
    end
  end
end
