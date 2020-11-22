class SuccessPaymentWorker
  include Sidekiq::Worker
  # sidekiq_options queue: :mailer

  def perform(user_id, link, title, track_code)
    PaymentMailer.success_payment(User.find_by(id: user_id),
                                  link,
                                  title, track_code).deliver_now
  end
end
