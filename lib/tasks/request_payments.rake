namespace :pay do
  task request: :environment do
    payments = PhotographerPayments::Payments.call
    payments.result.each do |payment|
      authentication = Pay::Authenticate.call
      if authentication.success?
        token = authentication.token
        photographer = Photographer.joins(:bank_account).
          where(id: payment.photographer_id).
          select("concat(first_name, ' ', last_name) full_name, bank_accounts.shaba").take(1)[0]
        if photographer
          uid = SecureRandom.urlsafe_base64
          result = Pay::Request.call(token: token,
                                     name: photographer.full_name,
                                     amount: payment.price,
                                     sheba: photographer.shaba,
                                     uid: uid)
          ids = PhotographerPayment.
            where("cashout_id is null and status = 2 and photographer_id = ?", payment.photographer_id).
            pluck(:id)
          if result.success?
            status = 2
            if result.data["status_code"].to_i == 1
              status = 5
            end
            ids.each do |p|
              PhotographerPayments::PhotographerPaymentUpdate.call(
                id: p,
                photographer_payment_data: { cashout_id: result.data["cashout_id"],
                                             status: status, uid: uid },
              )
            end
          else
            ids.each do |p|
              PhotographerPayments::PhotographerPaymentUpdate.call(
                id: p,
                photographer_payment_data: { error_messages: result.errors["message"],
                                             status: 6, uid: uid },
              )
            end
          end
        end
      end
    end
  end

  task photographer_payment_statuses: :environment do
    bank_gateway_id = BankGateway.find_by(name: "pay.ir").id
    payments = PhotographerPayment.select("cashout_id, photographer_id").
      where("status = ? and cashout_id is not null and bank_gateway_id = ?", 5, bank_gateway_id).group("cashout_id, photographer_id")

    payments.update_all(inquiry_at: Time.now)

    puts "size of projects are #{payments.size}"
    payments.each do |payment|
      authentication = Pay::Authenticate.call
      if authentication.success?
        token = authentication.token
        result = Pay::Status.call(token: token,
                                  cashout_id: payment.cashout_id)
        ids = PhotographerPayment.
          where("status = 5 and cashout_id = ?", payment.cashout_id).
          pluck(:id)
        if result.success?
          status = 5
          if result.data["status_code"].to_i == 4
            status = 3
          end

          ids.each do |id|
            PhotographerPayments::PhotographerPaymentUpdate.call(
              id: id,
              photographer_payment_data: { cashout_id: result.data["cashout_id"],
                                           status: status,
                                           deposit_referrer: result.data["deposit_referrer"],
                                           payment_date: Time.now },
            )
          end
          photographer = Photographer.find(payment.photographer_id)
          sum_price = PhotographerPayments::SumPrice.call(ids: ids).sum_price
          Photographers::NotifyPhotographerOfSettlement.call(mobile_number: photographer.mobile_number, amount: sum_price)
        else
          ids.each do |id|
            PhotographerPayments::PhotographerPaymentUpdate.call(
              id: id,
              photographer_payment_data: { error_messages: result.errors["message"],
                                           status: 6,
                                           payment_date: Time.now },
            )
          end
        end
      end
    end

    bank_gateway_id = BankGateway.find_by(name: "jibit.ir").id
    payments = PhotographerPayment.select("jibit_uid, photographer_id").
      where("status = ? and jibit_uid is not null and bank_gateway_id = ?", 5, bank_gateway_id).group("jibit_uid, photographer_id")

    payments.update_all(inquiry_at: Time.now)

    puts "size of projects are #{payments.size}"
    payments.each do |payment|
      authentication = Jibit::BatchAccessToken.call
      if authentication.success?
        token = authentication.token
        result = Jibit::Status.call(token: token,
                                    jibit_uid: payment.jibit_uid)
        ids = PhotographerPayment.
          where("status = 5 and jibit_uid = ?", payment.jibit_uid).
          pluck(:id)
        if result.success?
          status = 5
          if result.state == "TRANSFERRED"
            status = 3
          end
          if result.state == "FAILED" || result.state == "CANCELLED" || result.state == "CANCELLING"
            status = 6
          end

          ids.each do |id|
            PhotographerPayments::PhotographerPaymentUpdate.call(
              id: id,
              photographer_payment_data: { status: status,
                                           deposit_referrer: result.deposit_referrer,
                                           payment_date: Time.now },
            )
          end
          if result.state == "TRANSFERRED"
            sum_price = PhotographerPayments::SumPrice.call(ids: ids).sum_price
            photographer = Photographer.find(payment.photographer_id)
            Photographers::NotifyPhotographerOfSettlement.call(mobile_number: photographer.mobile_number, amount: sum_price)
          end
        else
          ids.each do |id|
            PhotographerPayments::PhotographerPaymentUpdate.call(
              id: id,
              photographer_payment_data: { error_messages: result.errors["message"],
                                           status: 6,
                                           payment_date: Time.now },
            )
          end
        end
      end
    end
  end
end
