class AddHasGalleryToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :has_gallery, :boolean , default: false
  end
end
