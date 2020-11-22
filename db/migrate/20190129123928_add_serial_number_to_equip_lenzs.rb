class AddSerialNumberToEquipLenzs < ActiveRecord::Migration[5.0]
  def change
    add_column :equip_lenzs, :serial_number, :string
  end
end
