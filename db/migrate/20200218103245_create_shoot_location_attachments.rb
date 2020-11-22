class CreateShootLocationAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :shoot_location_attachments do |t|
      t.integer :shoot_location_id
      t.string :photo
      t.timestamps
    end
  end
end
