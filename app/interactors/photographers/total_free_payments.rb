module Photographers
  class TotalFreePayments
    include Interactor

    def call
      photographer_id = context.photographer_id
      # if project is in happy_call state or check_out state
      total_free_payments = PhotographerPayment.where(photographer_id: photographer_id).joins(project: :reserve_step).where("cashout_id is null and (status = 2 or status = 6) and (reserve_steps.id = ? or reserve_steps.id = ?) and payment_type != 11", 16, 17).select(:id, :price)
      context.total_free_payments = total_free_payments
    end
  end
end
