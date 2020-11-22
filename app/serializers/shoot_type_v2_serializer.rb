class ShootTypeV2Serializer < ActiveModel::Serializer
  attributes :id, :avatar, :title, :order, :is_personal, :is_business

  def avatar
    object.avatar.url
  end
end
