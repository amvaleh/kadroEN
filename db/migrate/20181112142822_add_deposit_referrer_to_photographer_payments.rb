class AddDepositReferrerToPhotographerPayments < ActiveRecord::Migration[5.0]
  def change
    add_column(:photographer_payments, :deposit_referrer, :string)
  end
end
