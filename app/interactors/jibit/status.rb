module Jibit
  class Status
    include Interactor

    def call
      access_token = context.token
      url = "https://api.jibit.ir/trf/v1/transfers?transferID=#{context.jibit_uid}"
      response_status = HTTParty.get(url,
                                     :headers => { "Content-Type" => "application/json",
                                                   "Authorization" => "Bearer #{access_token}" })
      results_status = JSON.parse(response_status.body)
      context.state = results_status["transfers"][0]["state"]
      if context.state == "TRANSFERRED"
        context.deposit_referrer = context.jibit_uid
      else
        context.deposit_referrer = nil
      end
    end
  end
end
