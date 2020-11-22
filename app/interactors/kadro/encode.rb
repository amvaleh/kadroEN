module Kadro
  class Encode
    include Interactor
    def call
      expiration =1.days.from_now.to_i
      context.result = JWT.encode context.payload.merge(exp:expiration),Rails.application.secrets.secret_key_base
    end
  end
end
