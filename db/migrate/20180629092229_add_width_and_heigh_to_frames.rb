class AddWidthAndHeighToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :width, :integer
    add_column :frames, :height, :integer
  end
end
