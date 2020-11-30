module Projects
  class SendInformationToPhotographer
    include Interactor

    def call
      project = Project.find(context.project_id)
      hours = context.hours
      minutes = context.minutes
      short_url = Shortener::ShortenedUrl.generate("/#{Rails.application.routes.url_helpers.project_information_project_path(project)}")

      if hours == 0 and minutes == 0
        sms_message = <<-text
کادرو: پروژه عکاسی به عکاس دیگری واگذار شد.
        text
      else
        sms_message = <<-text
کادرو: پروژه جدید. لینک:
http://l.kadro.me/#{short_url.unique_key}
تاریخ پروژه:
#{project.start_time.to_date.to_pdate.to_s.tr('-', '/')} #{project.start_time.strftime("ساعت %H:%M")}
فقط با هماهنگی و رضایت کارفرما می توانید زمان پروژه را تغییر دهید.
        text
        if hours.present? and minutes.present?
          sms_message.concat("مهلت باقیمانده برای تایید: #{hours} ساعت و #{minutes} دقیقه می باشد.")
        end
      end

      res = SmsWorker.perform_async(sms_message, project.photographer.mobile_number)

      context.res = res
    end
  end
end