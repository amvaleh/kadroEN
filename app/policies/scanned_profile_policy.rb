class ScannedProfilePolicy < Struct.new(:user, :scanned_profile)
  def scanned_profile_show?
    has_scanned_profile?(user, scanned_profile)
  end

  private

  def has_scanned_profile?(user, scanned_profile)
    user.scanned_profile == scanned_profile
  end
end
