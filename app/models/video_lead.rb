class VideoLead < ApplicationRecord




  after_create :alert_admin

  def alert_admin
    sms_message = "ثبت درخواست تیزر جدید"
    SmsWorker.perform_async(sms_message, "09129335239")
    SmsWorker.perform_async(sms_message, "09353954916")
  end

end
