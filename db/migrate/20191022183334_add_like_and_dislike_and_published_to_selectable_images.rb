class AddLikeAndDislikeAndPublishedToSelectableImages < ActiveRecord::Migration[5.0]
  def change
    add_column :selectable_images, :like_number, :integer, default: 0
    add_column :selectable_images, :dislike_number, :integer, default: 0
    add_column :selectable_images, :published, :boolean, default: true
  end
end
