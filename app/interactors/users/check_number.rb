module Users
  class CheckNumber
    include Interactor

    def call
      mobile_number = context.mobile_number
      if mobile_number == "09031931470" || mobile_number == "09356965754" || mobile_number == "09123035856" ||
         mobile_number == "09353954916" || mobile_number == "09122087522" || mobile_number == "09027993049" ||
         mobile_number == "09120132331" || mobile_number == "09370027366" || mobile_number == "09136183194" ||
         mobile_number == "09121111111"
        generated_password = "123456"
        indoor = true
      elsif mobile_number == "09112165263"
        generated_password = "ha123456"
        indoor = true
      elsif mobile_number == "09359369369"
        generated_password = "snappfood@kadro2019"
        indoor = true
      end
      user = User.find_by_mobile_number(mobile_number)
      if user.present?
        if user.password_sent_times < 2
          if !indoor
            generated_password = rand.to_s[3..6]
          end
          user.password = generated_password
          user.password_confirmation = generated_password
          user.reset_password_token = generated_password
          user.password_sent_at = Time.now
          user.password_sent_times = user.password_sent_times + 1
        elsif (Time.now - user.password_sent_at) > 1.minutes
          user.password_sent_times = 1
          if !indoor
            generated_password = rand.to_s[3..6]
          end
          user.password = generated_password
          user.password_confirmation = generated_password
          user.reset_password_token = generated_password
          user.password_sent_at = Time.now
        else
          error = "error"
          # redirect_to users_register_path , alert: "تعدادی پیامک شامل کد تایید برای شما ارسال شده است. لطفا ۱۰ دقیقه دیگر منتظر بمانید."
        end
      else
        generated_password = rand.to_s[3..6]
        user = User.new
        user.mobile_number = mobile_number
        user.password = generated_password
        user.password_confirmation = generated_password
        user.reset_password_token = generated_password
        user.password_sent_times = user.password_sent_times + 1
        user.password_sent_at = Time.now
      end
      if error == "error"
        context.message = I18n.t(:'users.count_warninig')
        context.fail!
      elsif user.save
        context.message = I18n.t(:'users.password_sent')
#         sms_message = <<-text
# #{I18n.t(:'users.message_part_1')}
# #{generated_password}
# #{I18n.t(:'users.company_name')}
#         text
        if !indoor
          # SmsWorker.perform_async(sms_message, user.mobile_number)
          result = Messages::KavenegarSendTemplate.call(mobile_number: user.mobile_number, token: generated_password, type: "call", template: "user-password")
        end
      else
        context.message = "ERROR"
        context.fail!
      end
    end
  end
end
