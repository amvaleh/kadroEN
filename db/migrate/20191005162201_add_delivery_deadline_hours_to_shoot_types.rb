class AddDeliveryDeadlineHoursToShootTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_types, :delivery_deadline_hours, :integer
  end
end
