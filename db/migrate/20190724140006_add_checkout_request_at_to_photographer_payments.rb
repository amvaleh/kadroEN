class AddCheckoutRequestAtToPhotographerPayments < ActiveRecord::Migration[5.0]
  def change
    add_column :photographer_payments, :checkout_request_at, :datetime
  end
end
