module Galleries
  class ClearPassword
    include Interactor

    def call
      Gallery.where(slug: context.id).update_all(salt: nil, hashed_password: nil)
    end
  end
end