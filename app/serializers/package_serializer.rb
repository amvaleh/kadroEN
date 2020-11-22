class PackageSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :off_price, :digitals, :order, :order_in_duration, :shoot_type_id, :extra_price, :is_full, :is_active, :is_gold, :average_frames, :features

  def thumb_url
    object.file.url(:thumb)
  end

  def title
    if object.name.present?
      object.name
    elsif object.vip?
      "طلایی"
    elsif object.is_full?
      "استاندارد"
    else
      "اقتصادی"
    end
  end

  def order
    object.order.to_i
  end

  def off_price
    object.real_price
  end

  def order_in_duration
    if object.is_full == false
      1
    elsif object.is_full == true and object.vip == false
      2
    else
      3
    end
  end

  def is_gold
    object.vip
  end

  def average_frames
    object.feature_1
  end

  def features
    feature = []
    if object.feature_2.present?
      feature.push(object.feature_2)
    end
    if object.feature_3.present?
      feature.push(object.feature_3)
    end
    if object.feature_4.present?
      feature.push(object.feature_4)
    end
    if object.feature_5.present?
      feature.push(object.feature_5)
    end
    if object.feature_6.present?
      feature.push(object.feature_6)
    end
    if object.feature_7.present?
      feature.push(object.feature_7)
    end
    feature
  end
end
