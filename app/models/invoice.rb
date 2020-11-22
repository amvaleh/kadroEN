class Invoice < ApplicationRecord
  belongs_to :address, optional: true
  belongs_to :cart
  belongs_to :coupon
  belongs_to :cart
  has_many :invoice_items
  has_one :photographer_payment
  belongs_to :service_step

  scope :two_weeks_ago , -> {
    where(:updated_at =>(14.days.ago)..(Date.today.end_of_day))
  }
  after_save :check_service_step
  after_update :check_just_download

  def check_service_step
    if self.service_step_id_changed?
      step = ServiceStep.find_by_id(self.service_step_id).title
      if step.present?
        user = self.cart.user
        case step
        when "service_providing_print"
          message = <<-SMS
#{user.display_name} عزیز
سفارش شما دریافت و تا 48 ساعت آینده انجام خواهد شد.
پیش از ارسال با شما هماهنگ می گردد.
کادرو
          SMS
          SmsWorker.perform_async(message, user.mobile_number)
        when "service_providing_retouch"
          message = <<-SMS
#{user.display_name} عزیز
سفارش شما دریافت و تا 48 ساعت آینده انجام خواهد شد.
کادرو
          SMS
          SmsWorker.perform_async(message, user.mobile_number)
        when "service_providing_retouch_print"
          message = <<-SMS
#{user.display_name} عزیز
سفارش شما دریافت و تا 72 ساعت آینده انجام خواهد شد.
پیش از ارسال با شما هماهنگ می گردد.
کادرو
          SMS
          SmsWorker.perform_async(message, user.mobile_number)
        when "service_done_retouch"
          message = <<-SMS
#{user.display_name} عزیز
سفارش شما آماده و در بخش روتوش شده ها در گالری پروژه آپلود شده است.
کادرو
          SMS
          SmsWorker.perform_async(message, user.mobile_number)
        when "service_done_print"
          message = <<-SMS
#{user.display_name} عزیز
سفارش شما آماده ارسال است. بابت هماهنگی تماس گرفته شد اما پاسخگو نبودید.
کادرو
          SMS
          SmsWorker.perform_async(message, user.mobile_number)
        when "service_done_retouch_print"
          message = <<-SMS
#{user.display_name} عزیز
عکس های شما روتوش و در گالری پروژه آپلود و برای چاپ ارسال شده است.
پیش از ارسال با شما هماهنگ می گردد.
کادرو
          SMS
          SmsWorker.perform_async(message, user.mobile_number)
        end
      end
    end
  end

  def check_just_download
    if self.status_changed? && self.status == 1
      conditional = Invoices::HasOnlyDownload.call(cart_id: self.cart.id).result
      if conditional
        service = ServiceStep.find_by_title("service_finished")
        if self.service_step_id != service.id
          self.service_step_id = service.id
          self.save
        end
      end
    end

  end
end
