class KitPhotographyToolSerializer < ActiveModel::Serializer
  attributes :id, :count, :name

  def name
    object.photography_tool.name
  end
end
