class AddSerialNumberToEquipCameras < ActiveRecord::Migration[5.0]
  def change
    add_column :equip_cameras, :serial_number, :string
  end
end
