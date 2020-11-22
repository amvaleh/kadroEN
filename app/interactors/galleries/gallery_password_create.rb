module Galleries
  class GalleryPasswordCreate
    include Interactor

    def call
      gallery_form = GalleryForm.new(Gallery.find_by(slug: context.id))
      if gallery_form.validate(context.gallery_data)
        gallery_form.salt = SecureRandom.base64(8)
        gallery_form.hashed_password = Digest::SHA2.hexdigest(gallery_form.salt + context.gallery_data[:password])
        gallery_form.save
        context.gallery = gallery_form
      else
        context.gallery = gallery_form
        context.fail!
      end
    end
  end
end