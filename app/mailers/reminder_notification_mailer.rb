class ReminderNotificationMailer < ApplicationMailer
  layout "mailer/reminder/main"
  def user(user)
    @user=user
    mail(to: user.email, subject: 'یاددآور کادرو' , content_type:"text/html")
  end
  def photographer(user)
    @user=user
    mail(to: user.email, subject: 'یاددآور کادرو' , content_type:"text/html")
  end
end
