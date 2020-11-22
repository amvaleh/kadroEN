namespace :photographer_mailer_tasks do
  desc "TODO"
  task reminder_sign_up: :environment do
    Photographer.wating.each do |photographer|
      if photographer.sent_photographer_emails.count < 7
        if photographer.join_step.present?
          if photographer.join_step.name == "اطلاعات اولیه"
            if photographer.last_sign_in_at.present?
              if Time.now - 4.days < photographer.last_sign_in_at.to_time && photographer.last_sign_in_at.to_time < Time.now - 3.days
                EmailPhotographerRegistrationReminderWorker.perform_async(photographer.id,"three_days_past_from_fill_basic_info_reminder")
                puts photographer.email
                puts "three_days_past_from_fill_basic_info_reminder"
              end
              if Time.now - 8.days < photographer.last_sign_in_at.to_time && photographer.last_sign_in_at.to_time < Time.now - 7.days
                EmailPhotographerRegistrationReminderWorker.perform_async(photographer.id,"seven_days_past_from_fill_basic_info_reminder")
                puts photographer.email
                puts "seven_days_past_from_fill_basic_info_reminder"
              end
            end
          end
          if photographer.join_step.name == "تجهیزات عکاسی"
            if photographer.last_sign_in_at.present?
              if Time.now - 4.days < photographer.last_sign_in_at.to_time && photographer.last_sign_in_at.to_time < Time.now - 3.days
                EmailPhotographerRegistrationReminderWorker.perform_async(photographer.id,"three_days_past_from_fill_equipment_reminder")
                puts photographer.email
                puts "three_days_past_from_fill_equipment_reminder"
              end
              if Time.now - 8.days < photographer.last_sign_in_at.to_time && photographer.last_sign_in_at.to_time < Time.now - 7.days
                EmailPhotographerRegistrationReminderWorker.perform_async(photographer.id,"seven_days_past_from_fill_equipment_reminder")
                puts photographer.email
                puts "seven_days_past_from_fill_equipment_reminder"
              end
            end
          end
        end
      end
    end
  end

end
