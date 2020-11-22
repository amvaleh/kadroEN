class EmailInterviewPhotographer
  include Sidekiq::Worker

  def perform(photographer_id)
    res = PhotographerMailer.invite_to_interview(photographer_id).deliver_now
  end
end