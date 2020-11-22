module Projects
  class TellPhDeliverAtLocation
    include Interactor

    def call
      photographer_name = context.photographer_name
      user_name = context.user_name
      mobile_number = context.mobile_number
      sms_message = <<-text
#{photographer_name} عزیز
لطفا پس از انجام عکاسی #{user_name} عکس ها را در محل به ایشان تحویل دهید.
با احترام
کادرو
      text
      SmsWorker.perform_async(sms_message, mobile_number)
    end
  end
end

