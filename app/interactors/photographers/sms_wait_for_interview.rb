module Photographers
  class SmsWaitForInterview
    include Interactor

    def call
      photographer = context.photographer

      sms_message = <<-text
#{photographer.display_name} گرامی
پروفایل شما بررسی و تایید شده است و شما در صف انتظار برای تعیین وقت مصاحبه می باشید.
با شما تماس گرفته خواهد شد.
کادرو
      text
      SmsWorker.perform_async(sms_message, photographer.mobile_number)
    end
  end
end