class PhotoPolicy < Struct.new(:user, :photo)
  def photo_destroy?
    has_photo?(user, photo)
  end

  private

  def has_photo?(user, photo)
    photo.expertise.photographer == user
  end
end
