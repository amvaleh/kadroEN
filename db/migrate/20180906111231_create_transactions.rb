class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.string :afterwards_url
      t.string :email
      t.string :mobile_number
      t.float :amount
      t.string :slug
      t.string :message
      t.text :description
      t.integer :status
      t.string :track_number

      t.timestamps
    end
  end
end
