class CameraSerializer < ActiveModel::Serializer
  attributes :id, :brand, :model , :type
  def type
    "camera"
  end
end
