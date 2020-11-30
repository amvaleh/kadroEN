module Projects
  class SendCanceledProjectMessageToPhotographer
    include Interactor

    def call
      project = Project.find(context.project_id)
      day = project.start_time.to_date.to_pdate.strftime("%A")
      hour = project.start_time.strftime("%I:%M %p")
      short_url = Shortener::ShortenedUrl.generate("/projects/#{project.slug}/project_information")
      sms_message = <<-text
کادرو: پروژه عکاسی با مشخصات زیر لغو گردید.
http://l.kadro.me/#{short_url.unique_key}
          text
      res = SmsWorker.perform_async(sms_message, project.photographer.mobile_number)

      context.res = res
    end
  end
end
