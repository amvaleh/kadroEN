class CallRequest < ApplicationRecord
  validates :name, presence: true
  validates :phone_number, presence: true
  validates :max_budget, presence: true

  after_create :alert_admin

  def alert_admin
    sms_message = "ثبت درخواست مشاوره جدید"
    SmsWorker.perform_async(sms_message, "09206152175")
    SmsWorker.perform_async(sms_message, "09353954916")
    SmsWorker.perform_async(sms_message, "09123807488")
    SmsWorker.perform_async(sms_message, "09024608026")
  end
end
