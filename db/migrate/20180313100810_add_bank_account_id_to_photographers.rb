class AddBankAccountIdToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :bank_account_id, :integer
  end
end
