module Photographers
  class WaitingToPay
    include Interactor

    def call
      photographer_id = context.photographer_id
      payments = PhotographerPayment.where(photographer_id: photographer_id, status: 5).select(:id, :price)
      context.waiting_to_pay = payments
    end
  end
end