class RemoveCameraIdEquipmet < ActiveRecord::Migration[5.0]
  def change
    remove_column :equipments , :camera_id
    remove_column :equipments , :lenz_id
  end
end
