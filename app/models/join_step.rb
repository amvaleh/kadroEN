class JoinStep < ApplicationRecord

  has_one :photographer
  after_update :photographer_update

  def photographer_update
      photographer.update(:updated_at => Time.now) if photographer.present?
  end

end
