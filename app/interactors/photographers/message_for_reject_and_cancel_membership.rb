module Photographers
  class MessageForRejectAndCancelMembership
    include Interactor

    def call
      photographer = Photographer.find_by(id: context.photographer_id)
      mobile_number = photographer.mobile_number

      sms_message = <<text
#{photographer.display_name} عزیز
نتیجه بررسی پروفایل شما به ایمیلتان ارسال شده است.
باسپاس
کادرو
text
      SmsWorker.perform_async(sms_message, mobile_number)
      EmailRejectAndCancelMembership.perform_async(photographer.id)
    end
  end
end