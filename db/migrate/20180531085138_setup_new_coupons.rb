class SetupNewCoupons < ActiveRecord::Migration[5.0]
  def change
    add_column :coupons, :valid_from, :datetime, null: true
    add_column :coupons, :valid_until, :datetime, null: true
    add_column :coupons, :redemption_limit, :integer, default: 1, null: false
  end
end
