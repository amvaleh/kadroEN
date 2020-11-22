class PhotographerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :mobile_number, :avatar, :email, :static_number, :ideal_hours,
             :uid, :online_portfolio, :instagram, :linkedin, :twitter, :token

  def token
    Kadro::Encode.call(payload: {type: 1, user: object.id}).result
  end

  def avatar
    object.avatar.url
  end
end
