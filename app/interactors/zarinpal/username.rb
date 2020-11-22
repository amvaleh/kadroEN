module Zarinpal
  class Username
    include Interactor

    def call
      result = Zarinpal::Api.call(version: 'v3', api_method: 'username.json',
                    params: {username: 'abmahmoodi', check: true}).result
      if result['meta']['code'] == 200
        context.message = result['meta']['message']
      else
        context.result = result
        context.fail!
      end
    end
  end
end
