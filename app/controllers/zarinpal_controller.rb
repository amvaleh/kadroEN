class ZarinpalController < ActionController::Base
  def pay
    description = params[:description]
    email = params[:email]
    mobile_number = params[:mobile_number]
    project = Project.friendly.find(params[:project_id])
    if Rails.env.production?
      call_back = "https://app.kadro.me/zarinpal/verify"
    elsif Rails.env.development?
      call_back = "http://app.localhost:3000/"
    elsif Rails.env.staging?
      call_back = "http://185.53.143.141:3005/"
    end
    if !params['amount'].blank?
      if params['amount'].to_i > 99
        client = Savon.client(
            wsdl: "https://de.zarinpal.com/pg/services/WebGate/wsdl")
        response = client.call(:payment_request, message: {
            "MerchantID" => "c4427bd0-348a-11e7-89d9-005056a205be", # ای پی آی درگاه زرین پال شما
            "Amount" => params['amount'], # مبلغ پرداختی
            "Description" => description,
            "Email" => email,
            "Mobile" => mobile_number,
            "CallbackURL" => call_back # صفحه بازگشت از درگاه
        })
        results = response.body
        authority = results[:payment_request_response][:authority]
        status = results[:payment_request_response][:status]
        receipt = project.receipt
        receipt.track_code = authority
        receipt.save
        if status.to_i < 100
          render :text => "Some Thing's wrrong"
        else
          session[:AMOUNT] = params['amount'] # ذخیره ی موقف مبلغ در سشن
          redirect_to "https://www.zarinpal.com/pg/StartPay/#{authority}/Sep"
        end
      else
        render :text => "مبلغ نا معتبر است"
      end
    else
      render :text => "مبلغ را وارد کنید"
    end
  end

#   def verify
#     if !params['Authority'].blank?
#       client = Savon.client(wsdl: "https://de.zarinpal.com/pg/services/WebGate/wsdl")
#       response = client.call(:payment_verification, message: {
#           "MerchantID" => "c4427bd0-348a-11e7-89d9-005056a205be", # ای پی آی درگاه زرین پال شما
#           "Amount" => session[:AMOUNT], # مبلغ پرداختی که در سشن قرارداده شده بود
#           "Authority" => params['Authority']
#       })
#       session.delete(:AMOUNT)
#       results = response.body
#       status = results[:payment_verification_response][:status]
#       ref_id = results[:payment_verification_response][:ref_id]
#       receipt = Receipt.find_by_track_code(params['Authority'])
#       receipt.track_code = ref_id
#       receipt.save
#       @project = receipt.project
#       if status.to_i < 100
#         redirect_to receipt_project_path(@project), :alert => "تراکنش از طرف شما متوقف شد، درصورت علاقه مجددا اقدام کنید."
#         @project.set_reserve_step("canceled_payment")
#         @project.save
#       else
#         @project.is_payed = true
#         @project.set_reserve_step("wating_for_ph")
#         if @project.user.business.present?
#           profit = @project.package.price.to_f * ((100 - @project.package.photographer_commission).to_f / 100)
#           receipt.business_total = (profit * (@project.user.business.user_share) / 100).to_i
#           receipt.business_checkout = false
#           receipt.save
#         end
#         @project.save
#         # EmailProjectSubmitted.perform_async(@project)
#         sms_message = <<-text
#               سفارش شما ثبت شد،
#               کد پیگیری :‌ #{ref_id}
#               تیم کادرو
#               text
#               SmsWorker.perform_async(sms_message,@project.user.mobile_number)
#               # alert admin for the new project:
#               sms_message=<<-text
#               #{@project.shoot_type.title}#{@project.receipt.subtotal}
#               text
#               SmsWorker.perform_async(sms_message,"09027993049")
#               SmsWorker.perform_async(sms_message,"09397731953")
#               #
#               puts @project.user.mobile_number
#               redirect_to thank_you_project_path(@project) , :alert =>"کد پیگیری: #{ref_id}"
#             end
#           else
#             if Rails.env.production?
#               redirect_to "https://app.kadro.me/zarinpal/"
#             else
#               redirect_to "http://app.localhost:3000/zarinpal/"
#             end
#           end
#         end
#
#         SmsWorker.perform_async(sms_message, @project.user.mobile_number)
#         # alert admin for the new project:
#         sms_message = <<-text
# #{@project.shoot_type.title}#{@project.receipt.subtotal}
#         text
#         SmsWorker.perform_async(sms_message, "09027993049")
#         # SmsWorker.perform_async(sms_message,"09123035856")
#         #
#         puts @project.user.mobile_number
#         redirect_to thank_you_project_path(@project), :alert => "کد پیگیری: #{ref_id}"
#       end
#       if Rails.env.production?
#         redirect_to "https://app.kadro.me/zarinpal/"
#       else
#         redirect_to "http://app.localhost:3000/zarinpal/"
#       end
#
#


  def extrahour_pay
    description = params[:description]
    email = params[:email]
    mobile_number = params[:mobile_number]
    project = Project.friendly.find(params[:project_id])
    if Rails.env.production?
      call_back = "https://app.kadro.me/extrahour_zarinpal/verify"
    elsif Rails.env.development?
      call_back = "http://app.localhost:3000/"
    elsif Rails.env.staging?
      call_back = "http://185.53.143.141:3005/"
    end
    if !params['amount'].blank?
      if params['amount'].to_i > 99
        client = Savon.client(
            wsdl: "https://de.zarinpal.com/pg/services/WebGate/wsdl")
        response = client.call(:payment_request, message: {
            "MerchantID" => "c4427bd0-348a-11e7-89d9-005056a205be", # ای پی آی درگاه زرین پال شما
            "Amount" => params['amount'], # مبلغ پرداختی
            "Description" => description,
            "Email" => email,
            "Mobile" => mobile_number,
            "CallbackURL" => call_back # صفحه بازگشت از درگاه
        })
        results = response.body
        authority = results[:payment_request_response][:authority]
        status = results[:payment_request_response][:status]
        receipt = project.receipt
        receipt.extrahour_track_code = authority
        receipt.save
        if status.to_i < 100
          render :text => "Some Thing's wrrong"
        else
          session[:AMOUNT] = params['amount'] # ذخیره ی موقف مبلغ در سشن
          redirect_to "https://www.zarinpal.com/pg/StartPay/#{authority}/Sep"
        end
      else
        render :text => "مبلغ نا معتبر است"
      end
    else
      render :text => "مبلغ را وارد کنید"
    end
  end

  def extrahour_verify
    if !params['Authority'].blank?
      client = Savon.client(wsdl: "https://de.zarinpal.com/pg/services/WebGate/wsdl")
      response = client.call(:payment_verification, message: {
          "MerchantID" => "c4427bd0-348a-11e7-89d9-005056a205be", # ای پی آی درگاه زرین پال شما
          "Amount" => session[:AMOUNT], # مبلغ پرداختی که در سشن قرارداده شده بود
          "Authority" => params['Authority']
      })

      amount = session[:AMOUNT]
      session.delete(:AMOUNT)
      results = response.body
      status = results[:payment_verification_response][:status]
      ref_id = results[:payment_verification_response][:ref_id]
      receipt = Receipt.find_by_extrahour_track_code(params['Authority'])
      @project = receipt.project
      receipt.extrahour_track_code = ref_id

      if status.to_i < 100
        redirect_to extra_receipt_project_path(@project), :alert => "تراکنش از طرف شما متوقف شد، درصورت علاقه مجددا اقدام کنید."
        # render :text => "تراکنش از طرف کاربر متوقف شد"
      else
        receipt.extrahour_paid = receipt.extrahour_paid + amount.to_i
        receipt.total = (receipt.total.to_i + amount.to_i).to_s
        receipt.subtotal = (receipt.subtotal.to_i + amount.to_i).to_s
        # update this code according to settings
        ph_commission = ((Setting.find_by_var("photographer_extra_hour_commission").value.to_i).to_f / 100)
        receipt.ph_payment = (receipt.ph_payment.to_i + (amount.to_i * ph_commission)).to_i.to_s
        receipt.extra_paid = true
        receipt.save
        @project.save

        if @project.extra_hour_requested.present? and @project.extra_hour_requested != 0
          hours_added = Projects::CalculateExtraHours.call(project_id: @project.id).hours_added

          sms_message = <<-text
پرداخت تمدید پروژه به مدت#{hours_added}ساعت با موفقیت انجام شد.
کد پیگیری:#{ref_id}
کادرو
          text
          SmsWorker.perform_async(sms_message, @project.user.mobile_number)
        end


        redirect_to thank_you_project_path(@project.slug), :notice => "هزینه تمدید با موفقیت دریافت شد. با تشکر از شما"
      end
    else
      if Rails.env.production?
        redirect_to "https://app.kadro.me/zarinpal/"
      elsif Rails.env.development?
        redirect_to "http://app.localhost:3000/zarinpal/"
      elsif Rails.env.staging?
        redirect_to "http://185.53.143.141:3005/zarinpal/"
      end
    end
  end
end
