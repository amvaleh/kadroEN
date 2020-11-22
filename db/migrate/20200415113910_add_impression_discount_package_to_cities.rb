class AddImpressionDiscountPackageToCities < ActiveRecord::Migration[5.0]
  def change
    add_column :cities, :impression_discount_package, :integer, default: 100
  end
end
