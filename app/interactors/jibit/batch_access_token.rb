module Jibit
  class BatchAccessToken
    JIBIT_GENERATE_URI = "https://api.jibit.ir/trf/v1/tokens/generate"
    API_KEY = "xI8cvgx7LFpYOg6BA71MBmr7V7M4eJnF"
    SECRET_KEY = "Nwhefao7UBiVM5Zd78wK-Ub1JKA-PPgtpmU9wnLAThdxGvrfU_tFK2Iw8VDs"
    include Interactor
    require "httparty"

    def call
      if context.description.to_s == ""
        context.description = "واریز مبلغ"
      end
      response_token = HTTParty.post(JIBIT_GENERATE_URI,
                                     :body => { :apiKey => "#{API_KEY}",
                                                :secretKey => "#{SECRET_KEY}" }.to_json,
                                     :headers => { "Content-Type" => "application/json" })
      results_token = JSON.parse(response_token.body)

      context.token = results_token["accessToken"]
    end
  end
end
