module Galleries
  class CheckGalleryPassword
    include Interactor

    def call
      gallery = Gallery.find_by(slug: context.id)
      unless gallery.hashed_password == Digest::SHA2.hexdigest("#{gallery.salt}#{context.password}")
        context.fail!
      end
    end
  end
end