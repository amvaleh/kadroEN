module Photographers
  class DirectPhotographerMissed
    include Interactor

    def call
      if context.direct_photographer_missed.present?
        photographer = Photographer.find_by_uid(context.direct_photographer_missed)
        send_sms = true
        if photographer.notification_for_less_free_time.present?
          if (Time.now - photographer.notification_for_less_free_time.to_time)/86400 < 1
            send_sms = false
          end
        end
        if send_sms
          available_hours = FreeTimes::CalculateAvailableWeekHours.call(photographer_id: photographer.id).available_hours
          if available_hours < 30
            short_url = Shortener::ShortenedUrl.generate("/photographers/#{photographer.mobile_number}/times")
            sms_message = <<-text
            #{photographer.display_name} گرامی
            در این لحظه به علت کم بودن زمان تقویم کاری شما
            مشتری از رزرو مستقیم شما منصرف گردید
            با مراجعه به لینک زیر جهت افزایش زمان های خالی خود اقدام فرمایید.
            http://l.kadro.co/#{short_url.unique_key}
            text
            photographer.notification_for_less_free_time = Time.now
            photographer.save
            SmsWorker.perform_async(sms_message, photographer.mobile_number)
          end
        end
      end
    end
  end
end
