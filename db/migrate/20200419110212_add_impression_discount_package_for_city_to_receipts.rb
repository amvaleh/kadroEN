class AddImpressionDiscountPackageForCityToReceipts < ActiveRecord::Migration[5.0]
  def change
    add_column :receipts, :impression_discount_package_for_city, :integer, default: 0
  end
end
