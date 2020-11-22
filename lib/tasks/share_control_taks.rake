namespace :share_control_taks do
  desc "TODO"
  task request_sent_to_users: :environment do
    result = ShareControls::GetGalleriesForRequestSentToUser.call()
    result.data.each do |sample|
      short_url = Shortener::ShortenedUrl.generate("/galleries/#{sample.slug}/permission")
      sms_message = <<-text
#{sample.user_name} عزیز، با سلام، عکاس شما #{sample.ph_name} درخواست اجازه برای استفاده از #{sample.count} عکس به عنوان نمونه کار را برای شما قرارداده است. در صورتیکه مایل هستید به او اجازه دهید از طریق این لینک دسترسی را تعیین کنید:
http://l.kadro.co/#{short_url.unique_key}
با احترام
کادرو
      text
      puts sms_message
      res = SmsWorker.perform_async(sms_message, sample.user_mobile_number)
      ShareControls::SetRequestSentToUser.call(gallery_id: sample.id)
    end
  end

  desc "TODO"
  task permission_sent_to_photographer: :environment do
    result = ShareControls::GetGalleriesForPermissionSentToPhotographer.call()
    result.data.each do |sample|
      short_url = Shortener::ShortenedUrl.generate("/photographers/#{sample.ph_mobile_number}/to_shares")
      sms_message = <<-text
درخواست اجازه انتشار توسط #{sample.user_name} بررسی گردید و برای #{sample.count} عکس اجازه ی انتشار صادر شد.
لینک ورود به صفحه ی اجازه ی انتشار:
http://l.kadro.co/#{short_url.unique_key}
کادرو
      text
      puts sms_message
      res = SmsWorker.perform_async(sms_message, sample.ph_mobile_number)
      ShareControls::SetPermissionSentToPhotographer.call(gallery_id: sample.id)
    end
  end

end
