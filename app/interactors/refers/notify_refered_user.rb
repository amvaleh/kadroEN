module Refers
  class NotifyReferedUser
    include Interactor

    def call
      refer = Refer.find_by(key: context.key)
      user = refer.owner
      credit = context.credit

      sms_message = <<-text
#{user.display_name} عزیز
مبلغ #{credit} تومان بابت ثبت سفارش با کد دعوت شما، به اعتبارتان اضافه شد.
کادرو
      text
      SmsWorker.perform_async(sms_message, user.mobile_number)
    end
  end
end