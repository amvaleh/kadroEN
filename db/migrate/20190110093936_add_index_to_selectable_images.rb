class AddIndexToSelectableImages < ActiveRecord::Migration[5.0]
  def change
    add_index(:selectable_images, [:image_id, :image_type])
  end
end
