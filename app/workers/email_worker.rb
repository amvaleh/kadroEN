class EmailWorker
  include Sidekiq::Worker

  def perform(user)
    if user.class==User
      ReminderNotificationMailer.user(user).deliver_now
    elsif user.class==Photographer
      ReminderNotificationMailer.photographer(user).deliver_now
    end
  end
end
