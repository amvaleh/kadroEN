module Photos
  class PhotoDestroy
    include Interactor

    def call
      photo = Photo.find_by(id: context.id)
      if photo.present?
        Rw::Authorize.call(context.photographer, PhotoPolicy, :photo_destroy?, photo)
        context.photographer.create_activity :ph_delete_a_photo, owner: context.photographer, recipient: photo
        Photographers::CheckPhotographerJoinStep.call(photographer_id: context.photographer.id)
        photo.destroy
      else
        context.errors = I18n.t(:'photos.messages.not_found')
        context.fail!
      end
    end
  end
end
