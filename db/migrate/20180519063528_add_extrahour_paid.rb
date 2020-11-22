class AddExtrahourPaid < ActiveRecord::Migration[5.0]
  def change
    add_column :receipts, :extrahour_paid, :integer , default: 0
  end
end
