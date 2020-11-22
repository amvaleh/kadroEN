module PhotographerPayments
  class PhotographerPaymentCreate
    include Interactor
    
    def call
      photographer_payment_form = PhotographerPaymentForm.new(PhotographerPayment.new)
      if photographer_payment_form.validate(context.data)
        photographer_payment_form.save
        context.photographer_payment = photographer_payment_form
      else
        context.photographer_payment = photographer_payment_form
        context.fail!
      end
    end
  end
end