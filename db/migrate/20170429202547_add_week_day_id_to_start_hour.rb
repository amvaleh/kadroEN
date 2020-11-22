class AddWeekDayIdToStartHour < ActiveRecord::Migration[5.0]
  def change
    add_column :start_hours, :week_day_id, :integer
  end
end
