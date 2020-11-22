class CreateExpertiseWidgetAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :expertise_widget_attachments do |t|
      t.integer :expertise_widget_id
      t.string :photo
      t.timestamps
    end
  end
end
