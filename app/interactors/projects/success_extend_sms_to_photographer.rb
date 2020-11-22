module Projects
  class SuccessExtendSmsToPhotographer
    include Interactor

    def call
      hours_added = context.hours_added

      sms_message = <<-text
هزینه تمدید#{hours_added}ساعت عکاسی از کارفرما دریافت شد.
موفق باشید.
      text
      SmsWorker.perform_async(sms_message, context.mobile_number)
    end
  end
end