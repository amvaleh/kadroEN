class UserMailer < ApplicationMailer

  def send_coupon_for_birthday(slug)
    @coupon = Coupon.find(slug)
    @user = @coupon.user
    if @user.email.present?
      mail(to: @user.email, subject: "هدیه تولد شما ")
      @user.create_activity :send_url_zip_file_download
    end
  end

end
