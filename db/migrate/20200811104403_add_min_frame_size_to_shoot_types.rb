class AddMinFrameSizeToShootTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_types, :min_frame_size, :integer, default: 2
  end
end
