class CreateSelectableImages < ActiveRecord::Migration[5.0]
  def change
    create_table :selectable_images do |t|
      t.integer :image_id
      t.integer :image_type
      t.string :description

      t.timestamps
    end
  end
end
