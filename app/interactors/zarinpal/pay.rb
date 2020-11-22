module Zarinpal
  class Pay
    ZARINPAL_URI = "https://de.zarinpal.com/pg/services/WebGate/wsdl"
    MERCHANT_ID = "c4427bd0-348a-11e7-89d9-005056a205be"
    include Interactor

    def call
      if context.description.to_s == ""
        context.description = "واریز مبلغ"
      end
      client = Savon.client(wsdl: ZARINPAL_URI)
      response = client.call(:payment_request, message: {
                                                 "MerchantID" => MERCHANT_ID,
                                                 "Amount" => context.net_price,
                                                 "Description" => context.description,
                                                 "Email" => context.email,
                                                 "Mobile" => context.mobile_number,
                                                 "CallbackURL" => context.call_back,
                                               })
      results = response.body
      context.status = results[:payment_request_response][:status].to_i
      if results[:payment_request_response][:status].to_i < 100
        context.fail!
      end
      context.authority = results[:payment_request_response][:authority]
    end
  end
end
