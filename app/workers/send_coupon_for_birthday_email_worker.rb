class SendCouponForBirthdayEmailWorker
  include Sidekiq::Worker

  def perform(slug)
    res = UserMailer.send_coupon_for_birthday(slug).deliver_now
  end
end
