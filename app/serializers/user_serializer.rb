class UserSerializer < ActiveModel::Serializer
  attributes :display_name, :mobile_number, :slug

  def display_name
    unless object.full_name.present?
      if object.first_name.present?
        if object.last_name.present?
          object.first_name + " " + object.last_name
        end
      else
        object.mobile_number.last(4).to_s
      end
    else
      if object.full_name != "null"
        object.full_name
      else
        "کاربر"
      end
    end
  end
end
