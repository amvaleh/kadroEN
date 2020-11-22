module Kadro
  class GenerateSlug
    include Interactor

    def call
      random_token = ''
      loop do
        random_token = SecureRandom.urlsafe_base64(8, false)
        break random_token unless context.model.exists?(slug: random_token)
      end
      context.random_token = random_token
    end
  end
end