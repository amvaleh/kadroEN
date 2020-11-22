class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :afterwards_url, :email, :mobile_number, :amount, :slug, :message, :description, :status, :track_number
end
