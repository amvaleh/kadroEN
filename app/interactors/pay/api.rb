module Pay
  class Api
    include Interactor

    BASE_URI = 'https://pay.ir/api'

    def call
      context.result = HTTParty.post("#{BASE_URI}/#{context.version}/#{context.api_method}",
                                     'headers' => {'Content-Type': 'application/json'},
                                     :body => context.params)
    end
  end
end