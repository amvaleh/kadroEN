class AddAppliedTimesToCoupons < ActiveRecord::Migration[5.0]
  def change
    add_column :coupons, :applied_times, :integer
  end
end
