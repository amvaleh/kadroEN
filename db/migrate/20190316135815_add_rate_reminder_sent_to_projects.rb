class AddRateReminderSentToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :rate_reminder_sent, :boolean
  end
end
