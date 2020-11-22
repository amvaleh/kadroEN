class AddExifIdToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :exif_id, :integer
  end
end
