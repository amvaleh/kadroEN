module PhotographerPayments
  class BatchPayment
    include Interactor

    def call
      payments = PhotographerPayment.select("sum(price) sum_price, photographer_id").
        where("id in (?) and cashout_id is null and (status = 2 or status = 6)", context.ids).
        group(:photographer_id)

      payments.each do |p|
        if p.sum_price > 1000
          authentication = Pay::Authenticate.call
          if authentication.success?
            photographer = Photographer.joins(:bank_account).
              where(id: p.photographer_id).
              select("concat(first_name, ' ', last_name) full_name, bank_accounts.shaba").take(1)[0]
            if photographer
              uid = SecureRandom.urlsafe_base64
              result = Pay::Request.call(token: authentication.token,
                                         name: photographer.full_name,
                                         amount: p.sum_price.to_i * 10,
                                         sheba: photographer.shaba,
                                         uid: uid)
              ids = PhotographerPayment.
                where("cashout_id is null and (status = 2 or status = 6) and photographer_id = ? and id in (?)",
                      p.photographer_id, context.ids).
                pluck(:id)
              if result.success?
                status = 2
                if result.data["status_code"].to_i == 1
                  status = 5
                end
                bank_gateway_id = BankGateway.find_by(name: "pay.ir").id
                ids.each do |id|
                  PhotographerPayments::PhotographerPaymentUpdate.call(
                    id: id,
                    photographer_payment_data: { cashout_id: result.data["cashout_id"],
                                                 status: status, uid: uid,
                                                 error_messages: "",
                                                 checkout_request_at: Time.now,
                                                 bank_gateway_id: bank_gateway_id },
                  )
                end
                context.sum_price = p.sum_price
                context.message = "درخواست های تسویه حساب برای بانک ارسال شد."
                context.success = true
                context.cashout_id = result.data["cashout_id"]
              else
                ids.each do |id|
                  PhotographerPayments::PhotographerPaymentUpdate.call(
                    id: id,
                    photographer_payment_data: { error_messages: result.errors,
                                                 status: 6, uid: uid },
                  )
                  context.message = result.errors
                end
                context.success = false
              end
            end
          else
            context.message = authentication.errors
            context.success = false
          end
        else
          context.message = "جمع مبلغ کمتر از ۱۰۰۰ تومان است."
          context.success = false
        end
      end
    end
  end
end
