class ShootTypeSerializer < ActiveModel::Serializer
  attributes :id, :avatar, :title, :order, :is_personal
end
