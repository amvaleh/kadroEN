module Pay
  class Status
    include Interactor

    def call
      result = Pay::Api.call(version: 'v1', api_method: "cashout/status?token=#{context.token}",
                             params: {id: context.cashout_id}).result
      if result['status'] == 1
        context.data = result['data']
      else
        context.errors = result['message']
        context.fail!
      end
    end
  end
end