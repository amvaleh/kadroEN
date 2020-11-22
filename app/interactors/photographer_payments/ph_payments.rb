module PhotographerPayments
  class PhPayments
    include Interactor

    def call
      context.payments = PhotographerPayment.where('photographer_id = ?', context.photographer_id).order("created_at DESC")
    end
  end
end