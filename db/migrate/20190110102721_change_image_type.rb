class ChangeImageType < ActiveRecord::Migration[5.0]
  def change
    change_column(:selectable_images, :image_type, :string)
  end
end
