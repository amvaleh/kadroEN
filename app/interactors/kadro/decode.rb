module Kadro
  class Decode
    include Interactor
    def call
      context.result = JWT.decode(context.token,Rails.application.secrets.secret_key_base).first
    end
  end
end
