class ShootLocationSerializer < ActiveModel::Serializer
  attributes :title, :slug, :lat, :lng, :detail

  def lat
    if object.address.present?
      object.address.lattitude
    end
  end

  def lng
    if object.address.present?
      object.address.longtitude
    end
  end

  def detail
    if object.address.present?
      object.address.detail
    end
  end
end
