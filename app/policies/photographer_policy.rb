class PhotographerPolicy < Struct.new(:user, :photographer)
  def portfolio?
    has_access?(user, photographer)
  end

  private
  def has_access?(user, photographer)
    Photographer.where('id = ? and mobile_number = ?', user.id, photographer.mobile_number).count > 0
  end
end