class GalleryPolicy < Struct.new(:user, :gallery)
  def show?
    has_gallery?(user, gallery)
  end

  def password_create?
    has_gallery?(user, gallery)
  end

  def clear_password?
    has_gallery?(user, gallery) || user.class.name.underscore
    # false
  end

  private
  def has_gallery?(user, gallery)
    Gallery.joins(project: :user).where('users.id = ? and galleries.id = ?', user.id, gallery.id).count > 0
  end
end