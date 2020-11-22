class AddShareControlIdToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :share_control_id, :integer
  end
end
