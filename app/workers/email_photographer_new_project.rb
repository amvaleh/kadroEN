class EmailPhotographerNewProject
  include Sidekiq::Worker

  def perform(slug)
    res = ProjectMailer.information_to_ph(slug).deliver_now
  end
end
