module Photographers
  class NotifyPhotographerOfSettlement
    include Interactor

    def call
      mobile_number = context.mobile_number
      amount = context.amount

      sms_message = <<text
عکاس محترم، 
مبلغ #{amount } تومان با موفقیت تسویه شد.
کادرو
text
      SmsWorker.perform_async(sms_message, mobile_number)
    end
  end
end