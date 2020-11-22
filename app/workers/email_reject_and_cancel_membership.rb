class EmailRejectAndCancelMembership
  include Sidekiq::Worker

  def perform(photographer_id)
    res = PhotographerMailer.reject_and_cancel_membership(photographer_id).deliver_now
  end
end