class CreateEquipmentKits < ActiveRecord::Migration[5.0]
  def change
    create_table :equipment_kits do |t|
      t.integer :equipment_id
      t.integer :kit_id
      t.timestamps
    end
  end
end
