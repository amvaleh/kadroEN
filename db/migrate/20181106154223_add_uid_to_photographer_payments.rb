class AddUidToPhotographerPayments < ActiveRecord::Migration[5.0]
  def change
    add_column(:photographer_payments, :uid, :string)
  end
end
