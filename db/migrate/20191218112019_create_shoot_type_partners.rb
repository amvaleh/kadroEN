class CreateShootTypePartners < ActiveRecord::Migration[5.0]
  def change
    create_table :shoot_type_partners do |t|
      t.integer :shoot_type_id
      t.integer :partner_id

      t.timestamps
    end
  end
end
