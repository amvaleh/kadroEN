module Refers
  class CheckRefer
    include Interactor

    def call
      code = context.code
      refer = Refer.find_by(key: code)
      if refer.present?
        if context.is_signed_in
          user_id = context.user_id
          if refer.owner_id != user_id
            if Project.where(user_id: user_id, is_payed: true).size == 0
              context.free_credit = true
              response = 'ok'
              message = "تبریک! #{context.free_credit_value} تومان اعتبار رایگان برای شما فعال شد."
            else
              response = 'error'
              message = "این کد تخفیف تنها برای سفارش اول می باشد."
            end
          else
              response = 'error'
              message = "نمی توانید از کد دعوت خودتان استفاده کنید."
          end
        else
          response = 'error'
          message = "برای استفاده از این کد تخفیف باید لاگین کنید."
        end
      else
        response = 'error'
        message = "کد تخفیف یافت نشد."
      end

      context.response = response
      context.message = message
    end
  end
end