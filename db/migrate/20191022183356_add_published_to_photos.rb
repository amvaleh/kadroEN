class AddPublishedToPhotos < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :published, :boolean, default: true
  end
end
