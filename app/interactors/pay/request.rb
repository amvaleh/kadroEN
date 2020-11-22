module Pay
  class Request
    include Interactor

    def call
      result = Pay::Api.call(version: 'v1.2', api_method: "cashout/request?token=#{context.token}",
                             params: {amount: context.amount,
                                      name: context.name,
                                      sheba: context.sheba,
                                      uid: context.uid}).result
      if result['status'] == 1
        context.data = result['data']
      else
        context.errors = result['message']
        context.fail!
      end
    end
  end
end