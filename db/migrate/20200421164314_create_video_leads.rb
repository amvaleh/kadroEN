class CreateVideoLeads < ActiveRecord::Migration[5.0]
  def change
    create_table :video_leads do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.integer :budget
      t.text :detail
      t.timestamps
    end
  end
end
