class AddOriginalFilenameToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :original_filename, :string
  end
end
