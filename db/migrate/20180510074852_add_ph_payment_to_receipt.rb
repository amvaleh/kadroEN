class AddPhPaymentToReceipt < ActiveRecord::Migration[5.0]
  def change
    add_column :receipts, :ph_payment, :string , default: 0
  end
end
