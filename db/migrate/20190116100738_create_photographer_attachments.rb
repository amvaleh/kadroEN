class CreatePhotographerAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :photographer_attachments do |t|
      t.integer :photographer_id
      t.string :avatar

      t.timestamps
    end
  end
end
