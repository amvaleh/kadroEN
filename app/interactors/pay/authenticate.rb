module Pay
  class Authenticate
    include Interactor

    def call
      result = Pay::Api.call(version: 'v1', api_method: 'authenticate',
                    params: {mobile: '09353954916', password: 'newpay.irpassw0rdchristmas2019'}).result
      if result['status'] == 1
        context.token = result['token']
      else
        context.errors = result['message']
        context.fail!
      end
    end
  end
end
