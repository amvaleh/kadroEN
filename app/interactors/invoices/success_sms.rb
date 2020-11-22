module Invoices
  class SuccessSms
    include Interactor

    def call
      message = <<-SMS
#{I18n.t(:'invoices.messages.success_payment')}
#{I18n.t(:'invoices.messages.view_invoice')}
با تشکر از خرید شما
      SMS
      SmsWorker.perform_async(message, context.mobile_number)
    end
  end
end
