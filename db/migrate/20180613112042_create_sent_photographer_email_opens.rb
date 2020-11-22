class CreateSentPhotographerEmailOpens < ActiveRecord::Migration[5.0]
  def change
    create_table :sent_photographer_email_opens do |t|
      t.integer :sent_photographer_email_id , null: false
      t.string :name
      t.string :email
      t.string :ip_address
      t.string :opened
      t.timestamps
    end
  end
end
