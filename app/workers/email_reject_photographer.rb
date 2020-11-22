class EmailRejectPhotographer
  include Sidekiq::Worker

  def perform(photographer_id)
    res = PhotographerMailer.reject_photographer(photographer_id).deliver_now
  end
end
