module Transactions
  class Verify
    include Interactor

    def call
      api =
          if Rails.env.production?
            "89b6c136de623e621ac16e0c19af9484"
          else
            'test'
          end

      params = {'api' => api, 'transId' => context.trans_id}
      x = Net::HTTP.post_form(URI.parse('https://pay.ir/payment/verify'), params)
      data = JSON.parse(x.body)
      unless data['status'].to_i == 1
        context.error = data['status']
        context.fail!
      end
    end
  end
end