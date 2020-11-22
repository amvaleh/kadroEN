module Jibit
  class BatchRequest
    include Interactor
    require "httparty"

    def call
      access_token = context.token
      if Rails.env.production?
        url = "https://api.jibit.ir/trf/v1/transfers"
        body = {
          "batchID": context.uid,
          "submissionMode": "TRANSFER",
          "transfers": [{
            "transferID": context.uid,
            "transferMode": "ACH",
            "destination": "IR#{context.sheba}",
            "destinationFirstName": context.first_name,
            "destinationLastName": context.last_name,
            "amount": context.amount,
            "currency": "RIALS",
            "description": "تسویه حساب  #{context.first_name} #{context.last_name}",
          }],
        }.to_json
        response_batch = HTTParty.post(url, :body => body,
                                            :headers => { "Content-Type" => "application/json",
                                                          "Authorization" => "Bearer #{access_token}" })
        results_batch = JSON.parse(response_batch.body)
        context.totalAmountTransferred = results_batch["totalAmountTransferred"]
      elsif Rails.env.development?
        context.totalAmountTransferred = context.amount
      end
      if context.totalAmountTransferred == context.amount
        context.status = 1
      else
        context.fail!
      end
    end
  end
end
