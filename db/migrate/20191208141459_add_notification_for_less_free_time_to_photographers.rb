class AddNotificationForLessFreeTimeToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :notification_for_less_free_time, :datetime
  end
end
