class GalleryForm < Reform::Form
  property :password, virtual: true
  property :password_confirmation, virtual: true
  property :hashed_password
  property :salt

  validate :empty_password
  validate :password_not_confirmed
  validate :password_is_short

  private

  def empty_password
    return unless password == '' && password_confirmation == ''
    errors.add(:password, I18n.t(:'galleries.empty_password'))
  end

  def password_not_confirmed
    unless password == password_confirmation
      errors.add(:password, I18n.t(:'galleries.password_and_confirm_not_equal'))
    end
  end

  def password_is_short
    if password.length < 6
      errors.add(:password, I18n.t(:'galleries.password_is_short'))
    end
  end
end