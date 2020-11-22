class EmailIncompleteProfile
  include Sidekiq::Worker

  def perform(photographer_id)
    res = PhotographerMailer.incomplete_profile(photographer_id).deliver_now
  end
end
