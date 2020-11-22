class AddIsActiveToCoupon < ActiveRecord::Migration[5.0]
  def change
    add_column :coupons, :is_active, :boolean
    add_column :coupons, :used_times, :integer , :default => 0
  end
end
