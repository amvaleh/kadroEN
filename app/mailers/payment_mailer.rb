class PaymentMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def success_payment(user, link, title, track_code)
    @link = link
    @title = title
    @user = user
    @track_code = track_code
    mail(:to => user.email ,
               :subject => "#{user.display_name} #{I18n.t(:'invoices.messages.mail_message')} " ,
               :content_type => "text/html")

  end
end