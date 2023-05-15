class CallRequest < ApplicationRecord
  validates :name, presence: true
  validates :phone_number, presence: true
  validates :max_budget, presence: true

  after_create :alert_admin

  def alert_admin
    sms_message = "shootempire new CR."
    SmsWorker.perform_async(sms_message, "09353954916")
  end
end
