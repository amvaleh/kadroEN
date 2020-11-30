module Photographers
  class SmsInviteToInterview
    include Interactor

    def call
      photographer = Photographer.find(context.photographer_id)

      sms_message = <<-text
#{photographer.display_name} گرامی
اطلاعات مربوط به وقت مصاحبه شما در شرکت کادرو
تاریخ: #{photographer.interview_date.to_date.to_pdate.strftime("%A، %e %b")}
زمان: #{photographer.interview_date.strftime("%H:%M")}
تلفن: 09045572532  – بخش جذب عکاس
آدرس سایت: https://www.kadro.me
      text
      SmsWorker.perform_async(sms_message, photographer.mobile_number)
    end
  end
end
