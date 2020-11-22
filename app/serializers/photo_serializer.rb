class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :thumb_url, :large_url, :medium_url, :expertise_id, :size, :name

  def thumb_url
    object.file.url(:thumb)
  end

  def large_url
    object.file.url(:large)
  end

  def medium_url
    object.file.url(:medium)
  end

  def expertise_id
    object.expertise.id
  end

  def size
    object.file.size
  end

  def name
    object.file.url
  end
end
