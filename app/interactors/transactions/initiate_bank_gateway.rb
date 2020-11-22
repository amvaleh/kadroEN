module Transactions
  class InitiateBankGateway
    include Interactor

    def call

      transaction = Transaction.find_by(slug: context[:slug])
      # byebug
      if transaction.present?

        if Rails.env.production?
          call_back = "https://app.kadro.co/transactions/nailedit"
          api = "89b6c136de623e621ac16e0c19af9484"
        else
          call_back = "http://app.localhost:3000/transactions/nailedit"
          api = 'test'
        end

        if !transaction.amount.blank?
          if transaction.amount.to_i > 999
            params = {'api' => api, 'amount' => transaction.amount , 'redirect' => call_back , 'mobile' => transaction.mobile_number , 'factorNumber' => transaction.id , 'description' => transaction.description }
            x = Net::HTTP.post_form(URI.parse('https://pay.ir/payment/send'), params)
            puts x.body
            data = JSON.parse(x.body)
            status = data["status"]
            transaction_id = data["transId"]
            if status == 1
              updated = Transactions::TransactionUpdate.call(slug:transaction.slug, data: { track_number: transaction_id,status: status })
              context.track_number = transaction_id
            else
              message = data["errorMessage"]
              error = data["errorCode"]
              updated = Transactions::TransactionUpdate.call(slug:transaction.slug, data: { track_number: error,status: status, message: message })
              context.fail!
            end
            # return afterwards_url to update receipt or whatever
            # context.result =
          end
        end
      else
        context.message = "تراکنش موجود نیست!"
        context.fail!
      end

    end


  end
end
