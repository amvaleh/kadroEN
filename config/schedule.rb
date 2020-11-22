# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
env :PATH, ENV["PATH"]
set :output, "cron.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
#
every 1.day, at: "08:00 pm" do
  rake "user_reminder_to_rate"
  rake "user_tasks:user_reminder_to_see_gallery"
end

every 1.day, at: "01:00 pm" do
  rake "share_control_taks:permission_sent_to_photographer"
  rake "share_control_taks:request_sent_to_users"
end

every :hour do
  #  rake "photographer_tasks:ph_backstage_reminder"
  rake "ph_project_reminder"
  rake "ph_project_reminder_1_hour_before_start_time"
  rake "is_shooted"
  puts "done remind to ph"
  rake "passed_72hour"
  puts "update project 72 hour"
  #  rake "reminder_continue_email"
  rake "reminder_for_upload_to_photographer"
  rake "check_not_approved_projects"
  rake "general_tasks:check_memory_plus_reserve_step"
  rake "general_tasks:check_qualified_amount"
end

every 5.minutes do
  rake "do_you_wanna_extend"
end


every "0 16 20 * *" do
  rake "address_tasks:get_city_for_addresses"
end

every 1.day, at: "4:00 am" do
  command "backup perform -t db_backup -c /home/deploy/Backup/models/db_backup.rb"
  rake "photographer_tasks:calculate_rate"
  rake "gallery_tasks:check_zip_created_at"
end

every 1.day, at: "9:00 am" do
  rake "user_tasks:check_birthday"
end

every 1.day, at: "00:30 am" do
  rake "coupon_tasks:check_in_range_is_active"
  rake "selectable_image_tasks:publish_false_for_unapproved_ph"
  rake "selectable_image_tasks:remove_not_exist"
end

every 1.day, at: "01:00 pm" do
  rake "photographer_mailer_tasks:reminder_sign_up"
  # rake "feed_back_tasks:remind_to_user_for_gallery"
  rake "pay:photographer_payment_statuses"
end

every 1.day, at: "11:00 pm" do
  command "cd /home/deploy/kadro_repo/kadro.git && git fetch origin '*:*'"
end

every 30.minutes do
  rake "user_tasks:project_started_sms"
end

every 25.days, at: "10:00 pm" do
  rake "update_your_calendar_reminder"
end

every 1.week, :at => '5:00 am' do
  rake '-s sitemap:refresh CONFIG_FILE="config/main_sitemap.rb"'
  rake '-s sitemap:refresh CONFIG_FILE="config/pro_sitemap.rb"'
  rake '-s sitemap:refresh CONFIG_FILE="config/locations_sitemap.rb"'
end

# Learn more: http://github.com/javan/whenever
