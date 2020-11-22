module Photographers
  class NotifyForExtend
    include Interactor

    def call
      mobile_number = context.mobile_number
      sms_message = context.sms_message
      SmsWorker.perform_async(sms_message, mobile_number)
    end
  end
end