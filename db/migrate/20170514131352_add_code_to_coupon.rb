class AddCodeToCoupon < ActiveRecord::Migration[5.0]
  def change
    add_column :coupons, :code, :string
  end
end
