module PhotographerPayments
  class PhotographerPaymentUpdate
    include Interactor

    def call
      photographer_payment_form = PhotographerPaymentForm.new(PhotographerPayment.find_by(id: context.id))
      if photographer_payment_form.validate(context.photographer_payment_data)
        photographer_payment_form.save
        context.photographer_payment = photographer_payment_form
      else
        context.photographer_payment = photographer_payment_form
        context.fail!
      end
    end
  end
end