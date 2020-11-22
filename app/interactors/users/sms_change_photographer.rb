module Users
  class SmsChangePhotographer
    include Interactor

    def call
      project = Project.find(context.project_id)
      short_url = Shortener::ShortenedUrl.generate("/projects/#{project.slug}/alternate_photographers")
      reason_for_reject = ReasonForReject.find_by(id: context.reason_for_reject_id)
      sms_message = <<-text
#{project.user.display_name} عزیز،
متاسفانه درخواست رزرو عکاسی #{project.shoot_type.title} بدلیل #{reason_for_reject.user_notice} توسط #{project.photographer.display_name} لغو گردید.
نگران نباشید،
از طریق لینک زیر می توانید عکاس جایگزین را انتخاب کنید یا اجازه دهید پشتیبانی کادرو به صورت خودکار عکاس دیگری تعیین کند.
http://l.kadro.co/#{short_url.unique_key}
وضعیت پروژه: درحال تغییر عکاس
با احترام
      text
      SmsWorker.perform_async(sms_message, project.user.mobile_number)
      sms_message2 = <<-text
#{project.photographer.display_name} به دلیل #{reason_for_reject.name} لغو کرد.
-http://l.kadro.co#{short_url.unique_key}
      text
      SmsWorker.perform_async(sms_message2, "09206152175")
      SmsWorker.perform_async(sms_message2, "09353954916")
      SmsWorker.perform_async(sms_message2, "09123807488")
      SmsWorker.perform_async(sms_message2, "09024608026")
    end
  end
end
