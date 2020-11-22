class AddBankGatewayIdToPhotographerPayments < ActiveRecord::Migration[5.0]
  def change
    add_column :photographer_payments, :bank_gateway_id, :integer
  end
end
