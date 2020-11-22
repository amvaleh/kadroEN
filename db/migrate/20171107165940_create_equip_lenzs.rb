class CreateEquipLenzs < ActiveRecord::Migration[5.0]
  def change
    create_table :equip_lenzs do |t|
      t.integer :lenz_id
      t.integer :equipment_id

      t.timestamps
    end
  end
end
