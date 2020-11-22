class CreateSelectableImageShootTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :selectable_image_shoot_types do |t|
      t.integer :selectable_image_id
      t.integer :shoot_type_id

      t.timestamps
    end
    add_foreign_key(:selectable_image_shoot_types, :selectable_images, column: :selectable_image_id, index: true)
    add_foreign_key(:selectable_image_shoot_types, :shoot_types, column: :shoot_type_id, index: true)
  end
end
