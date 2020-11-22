class EquipmentSerializer < ActiveModel::Serializer
  attributes :id, :photographer_id, :small_product_kit, :large_product_kit, :portable_light, :portable_studio_kit,
             :light_studio_kit
end