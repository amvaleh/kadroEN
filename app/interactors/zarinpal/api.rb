module Zarinpal
  class Api
    include Interactor

    BASE_URI = 'https://api.zarinpal.com/rest'
    AUTHORIZATION = '112233'

    def call
      context.result = HTTParty.post("#{BASE_URI}/#{context.version}/#{context.api_method}",
                                     'headers' => {'Content-Type': 'application/json',
                                     'Authorization': AUTHORIZATION},
                                     :body => context.params)
    end
  end
end