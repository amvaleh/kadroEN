class AddJibitUidToPhotographerPayments < ActiveRecord::Migration[5.0]
  def change
    add_column(:photographer_payments, :jibit_uid, :string)
  end
end
