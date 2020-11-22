class EmailPhotographerRegistrationReminderWorker
  include Sidekiq::Worker

  def perform(photographer_id,reminder)
    if reminder=="three_days_past_from_fill_basic_info_reminder"
      PhotographerMailer.three_days_past_from_fill_basic_info_reminder(photographer_id).deliver_now
    elsif reminder=="seven_days_past_from_fill_basic_info_reminder"
      PhotographerMailer.seven_days_past_from_fill_basic_info_reminder(photographer_id).deliver_now
    elsif reminder=="three_days_past_from_fill_equipment_reminder"
      PhotographerMailer.three_days_past_from_fill_equipment_reminder(photographer_id).deliver_now
    elsif reminder=="seven_days_past_from_fill_equipment_reminder"
      PhotographerMailer.seven_days_past_from_fill_equipment_reminder(photographer_id).deliver_now
    end
  end
end
