namespace :feed_back_tasks do
  desc "Remind to user for fill the feed back form"
  task remind_to_user_for_gallery: :environment do
    period = Setting.find_by_var("reminder_completing_feedback_period_day").value.to_i
    projects = Project.send_customer.where.not(id: FeedBack.select(:project_id).uniq)
    final_projects = projects.where('send_customer_at BETWEEN ? AND ?', Time.now - period.day - 1.day, Time.now - period.day)
    final_projects.each do |project|
      short_url = Shortener::ShortenedUrl.generate("/feed_backs/#{project.slug}")

      user = project.user
      sms_message = <<-text
#{user.display_name} عزیز خوشحال می شویم اگر نظر شما را در مورد تجربه عکاسی #{project.shoot_type.title} تان را با آقای #{project.photographer.display_name} ، داشته باشیم.
http://l.kadro.co/#{short_url.unique_key}
با تشکر کادرو
      text
      SmsWorker.perform_async(sms_message, user.mobile_number)

      if user.email.present?
        EmailReminderForFeedBackUserWorker.perform_async(project.id)
      end
    end
  end

end
