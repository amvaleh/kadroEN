class KitSerializer < ActiveModel::Serializer
  attributes :id, :type, :photography_tools, :persian_title
  def type
    "kit"
  end

  def photography_tools
    kit = Kit.where(id: object.id).take(1)[0]
    ActiveModelSerializers::SerializableResource.new(
      kit.kit_photography_tools, each_serializer: KitPhotographyToolSerializer).as_json
  end
end
