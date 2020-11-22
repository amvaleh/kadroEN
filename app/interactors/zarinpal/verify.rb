module Zarinpal
  class Verify
    ZARINPAL_URI = 'https://de.zarinpal.com/pg/services/WebGate/wsdl'
    MERCHANT_ID = 'c4427bd0-348a-11e7-89d9-005056a205be'
    include Interactor

    def call
      client = Savon.client(wsdl: ZARINPAL_URI)
      response = client.call(:payment_verification, message: {
          "MerchantID" => MERCHANT_ID,
          "Amount" => context.net_price,
          "Authority" => context.authority
      })
      results = response.body
      ref_id = results[:payment_verification_response][:ref_id]
      if results[:payment_verification_response][:status].to_i < 100
        context.fail!
      else
        context.ref_id = ref_id
      end
    end
  end
end