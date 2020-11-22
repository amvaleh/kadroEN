class CallSerializer < ActiveModel::Serializer
  attributes :id, :photographer_id, :user_id, :rate
end
