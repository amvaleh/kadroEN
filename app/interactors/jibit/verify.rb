module Jibit
  class Verify
    include Interactor
    require "httparty"

    def call
      access_token = context.access_token
      url = "https://api.jibit.ir/ppg/v2/orders/#{context.authority}/verify"
      response_verify = HTTParty.get(url,
                                     :headers => { "Content-Type" => "application/json",
                                                   "Authorization" => "Bearer #{access_token}" })
      results_verify = JSON.parse(response_verify.body)
      status = results_verify["status"]
      if status == "Successful"
        context.ref_id = context.authority
      else
        context.fail!
      end
    end
  end
end
