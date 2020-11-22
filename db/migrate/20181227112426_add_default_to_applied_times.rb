class AddDefaultToAppliedTimes < ActiveRecord::Migration[5.0]
  def change
    change_column_default :coupons, :applied_times, 0
  end
end
