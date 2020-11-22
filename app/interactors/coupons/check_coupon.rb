module Coupons
  class CheckCoupon
    include Interactor

    def call
      code = context.code

      if Coupon.all.where(code: code).any?
        coupon = Coupon.where(code: code).first
        if coupon.valid_from.present? && coupon.valid_until.present?
          in_range = Time.now.between?(coupon.valid_from, coupon.valid_until)
        elsif !coupon.valid_from && !coupon.valid_until
          in_range = true
        else
          in_range = false
        end
        if in_range
          if coupon.redemption_limit > coupon.used_times
            if coupon.is_active
                context.successful = true
                context.coupon = coupon
            else
              context.result = {response: 'error', message: "این کد تخفیف هم اکنون فعال نیست."}
            end
          else
            context.result = {response: 'error', message: "این کد تخفیف قبلا استفاده شده است."}
          end
        else
          context.result = {response: 'error', message: "متاسفانه شما در این زمان مجاز به استفاده از این کد تخفیف نیستید."}
        end
      else
        context.result = {response: 'error', message: "این کد تخفیف هم اکنون فعال نیست."}
      end
    end
  end
end