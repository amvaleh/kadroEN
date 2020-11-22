module Photographers
  class TotalReadyToPay
    include Interactor

    def call
      photographer_id = context.photographer_id
      # if project is in happy_call state or check_out state
      total_ready_to_pay = PhotographerPayment.where(photographer_id: photographer_id).joins(project: :reserve_step).where("cashout_id is null and (status = 2 or status = 6) and (payment_type = 11 or reserve_steps.id = ? or reserve_steps.id = ?)", 16, 17).select(:id, :price)
      context.total_ready_to_pay = total_ready_to_pay
    end
  end
end
