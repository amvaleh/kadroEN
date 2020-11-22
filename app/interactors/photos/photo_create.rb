module Photos
  class PhotoCreate
    include Interactor

    def call
      photo = Photo.new(file: context.data[:file])
      shoot_type = ShootType.find(context.data[:shoot_type_id])
      expertise = context.data[:expertise_id] ? Expertise.find(context.data[:expertise_id]) : nil
      photographer = Photographer.find(context.data[:photographer_id])
      if expertise.present?
        photo.expertise = expertise
      else
        expertise = Expertise.where(:shoot_type => ShootType.find(shoot_type) , :photographer=>photographer).first
        if expertise.present?
          photo.expertise = expertise
        else
          expertise = Expertise.create(shoot_type_id: shoot_type.id, photographer_id: photographer.id)
          photo.expertise = expertise
          photographer.create_activity :ph_add_expertise, owner: photographer, recipient: expertise
        end
      end
      if photo.save
        context.photo = photo
        photographer.create_activity :ph_add_photo, owner: photographer, recipient: photo
        Photographers::CheckPhotographerJoinStep.call(photographer_id: context.data[:photographer_id])
      else
        context.errors = photo.errors.messages
        context.fail!
      end
    end
  end
end
