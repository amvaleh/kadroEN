class AddExifIdToPhotos < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :exif_id, :integer
  end
end
