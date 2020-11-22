class AddHalfHourExtendCostToShootTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_types, :half_hour_extend_cost, :integer, default: 70000
  end
end
