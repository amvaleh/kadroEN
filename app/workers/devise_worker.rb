class DeviseWorker
  include Sidekiq::Worker
  # sidekiq_options queue: :mailer

  def perform(user_id)
    user = Photographer.find(user_id)
    Devise::Mailer.confirmation_instructions(user, user.confirmation_token, {}).deliver
  end
end
