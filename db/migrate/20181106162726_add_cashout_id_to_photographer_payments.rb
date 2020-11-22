class AddCashoutIdToPhotographerPayments < ActiveRecord::Migration[5.0]
  def change
    add_column(:photographer_payments, :cashout_id, :integer)
  end
end
