class AddInvoiceIdToPhotographerPayments < ActiveRecord::Migration[5.0]
  def change
    add_column :photographer_payments, :invoice_id, :integer
  end
end
