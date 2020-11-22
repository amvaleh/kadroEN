class ExpertisePolicy < Struct.new(:user, :expertise)
  def expertise_destroy?
    has_expertise?(user, expertise)
  end

  private

  def has_expertise?(user, expertise)
    expertise.photographer == user
  end
end
