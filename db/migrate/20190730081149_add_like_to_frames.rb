class AddLikeToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :like, :boolean, default: false
  end
end
