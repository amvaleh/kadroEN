class ExpertiseSerializer < ActiveModel::Serializer
  attributes :id, :shoot_type_id, :photographer_id, :samples, :photos

  # has_many :photos
  def photos
    photos = Photo.where(expertise_id: object.id)

    ActiveModelSerializers::SerializableResource.new(
        photos, each_serializer: PhotoSerializer).as_json
  end
end