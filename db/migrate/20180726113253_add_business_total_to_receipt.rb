class AddBusinessTotalToReceipt < ActiveRecord::Migration[5.0]
  def change
    add_column :receipts, :business_total, :integer , default: 0
    add_column :receipts, :business_checkout, :boolean , default: true
  end
end
