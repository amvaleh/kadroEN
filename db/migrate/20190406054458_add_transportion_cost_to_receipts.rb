class AddTransportionCostToReceipts < ActiveRecord::Migration[5.0]
  def change
    add_column :receipts, :transportion_cost, :float, default: 0
  end
end
