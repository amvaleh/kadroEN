class CreateBankAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_accounts do |t|
      t.integer :photographer_id
      t.string :card_number
      t.string :shaba
      t.string :card_name
      t.string :bank_name
      t.timestamps
    end
    add_index :bank_accounts, :photographer_id
  end
end
