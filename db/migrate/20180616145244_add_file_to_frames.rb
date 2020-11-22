class AddFileToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :file, :string
  end
end
