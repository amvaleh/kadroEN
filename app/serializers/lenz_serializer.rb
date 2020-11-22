class LenzSerializer < ActiveModel::Serializer
  attributes :id, :brand, :model, :type
  def type
    "lenz"
  end
end
