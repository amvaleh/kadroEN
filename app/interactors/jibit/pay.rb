module Jibit
  class Pay
    JIBIT_GENERATE_URI = "https://api.jibit.ir/ppg/v2/tokens/generate"
    JIBIT_ORDER_URI = "https://api.jibit.ir/ppg/v2/orders"
    MERCHANT_CODE = "XbHZzDyqRGbD-_nU_S4FfbR8yme3aEgO"
    PASSWORD = "DiNpY5gE-zZICtgJP1OBl3NChQWdHyT92bHfPkVHulYNQ-qPZT7ubzmhh_Bg"
    include Interactor
    require "httparty"

    def call
      if context.description.to_s == ""
        context.description = "واریز مبلغ"
      end
      response_token = HTTParty.post(JIBIT_GENERATE_URI,
                                     :body => { :merchantCode => "#{MERCHANT_CODE}",
                                                :password => "#{PASSWORD}" }.to_json,
                                     :headers => { "Content-Type" => "application/json" })
      results_token = JSON.parse(response_token.body)
      access_token = results_token["accessToken"]
      response_orders = HTTParty.post(JIBIT_ORDER_URI,
                                      :body => { :amount => context.net_price,
                                                 :currency => "RIALS",
                                                 :referenceNumber => context.slug,
                                                 :userIdentifier => context.mobile_number,
                                                 :callbackUrl => context.call_back,
                                                 :description => context.description }.to_json,
                                      :headers => { "Content-Type" => "application/json",
                                                    "Authorization" => "Bearer #{access_token}" })
      results_orders = JSON.parse(response_orders.body)
      context.psp_switching_url = results_orders["pspSwitchingUrl"]
      context.order_identifier = results_orders["orderIdentifier"]
      context.authority = context.order_identifier
      context.access_token = access_token
    end
  end
end
