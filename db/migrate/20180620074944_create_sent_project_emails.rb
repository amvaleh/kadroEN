class CreateSentProjectEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :sent_project_emails do |t|
      t.integer :project_id , null: false
      t.string :email
      t.string :name
      t.datetime :sent
      t.integer :number_of_seen , default: 0
      t.integer :absent_day
      t.boolean :opened , defult: false
      t.timestamps
    end
  end
end
