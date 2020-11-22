module Photographers
  class FollowingProjectsPay
    include Interactor

    def call
      photographer_id = context.photographer_id
      payments = PhotographerPayment.where(photographer_id: photographer_id).joins(project: :reserve_step).where('status = 2 and reserve_steps.id != ? and reserve_steps.id != ?',16,17).select(:id, :price)
      context.payments = payments
    end
  end
end