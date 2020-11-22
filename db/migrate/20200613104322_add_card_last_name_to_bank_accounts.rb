class AddCardLastNameToBankAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :bank_accounts, :card_last_name, :string
  end
end
