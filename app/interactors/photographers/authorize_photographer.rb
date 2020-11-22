module Photographers
  class AuthorizePhotographer
    include Interactor

    def call
      photographer = Photographer.where(slug: context.id).take(1)[0]
      Rw::Authorize.call(context.photographer, PhotographerPolicy, :portfolio?, photographer)
    end
  end
end