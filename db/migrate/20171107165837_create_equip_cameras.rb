class CreateEquipCameras < ActiveRecord::Migration[5.0]
  def change
    create_table :equip_cameras do |t|
      t.integer :camera_id
      t.integer :equipment_id

      t.timestamps
    end
  end
end
