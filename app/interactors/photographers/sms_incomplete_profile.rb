module Photographers
  class SmsIncompleteProfile
    include Interactor

    def call
      photographer_id = context.photographer_id
      photographer = Photographer.find(photographer_id)

        sms_message = <<-text
#{photographer.display_name} عزیز
نتیجه بررسی پروفایل شما در واتس آپ ارسال شده است.
کادرو
        text
        SmsWorker.perform_async(sms_message, photographer.mobile_number)

    end
  end
end