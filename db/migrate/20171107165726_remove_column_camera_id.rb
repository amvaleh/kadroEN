class RemoveColumnCameraId < ActiveRecord::Migration[5.0]
  def change
    remove_column :equipment , :camera_id
    remove_column :equipment , :lenz_id
  end
end
