class AddSizeToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :size, :string
  end
end
