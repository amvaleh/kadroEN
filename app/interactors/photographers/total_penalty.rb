module Photographers
  class TotalPenalty
    include Interactor

    def call
      photographer_id = context.photographer_id
      total_penalty = PhotographerPayment.where(photographer_id: photographer_id).where("cashout_id is null and (status = 2 or status = 6) and payment_type = 11").select(:id, :price)
      context.total_penalty = total_penalty
    end
  end
end
