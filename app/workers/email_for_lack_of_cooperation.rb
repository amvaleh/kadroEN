class EmailForLackOfCooperation
  include Sidekiq::Worker

  def perform(photographer_id)
    res = PhotographerMailer.lack_of_cooperation(photographer_id).deliver_now
  end
end