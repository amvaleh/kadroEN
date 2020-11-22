class AddMaxFrameSizeToShootTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_types, :max_frame_size, :integer, default: 5
  end
end
