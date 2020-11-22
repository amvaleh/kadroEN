class UpdateReceiptScenario < ActiveRecord::Migration[5.0]
  def change
    add_column :receipts, :filedownload_total, :integer , default: 0
    add_column :receipts, :extrahour_total, :integer , default: 0
    add_column :receipts, :print_total, :integer , default: 0
  end
end
