class EmailReminderForFeedBackUserWorker
  include Sidekiq::Worker

  def perform(project_id)
    ProjectMailer.reminder_for_feed_back_user(project_id).deliver_now
  end
end
