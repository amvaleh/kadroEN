class Experience < ApplicationRecord

  belongs_to :photographer
  after_update :photographer_update
  before_create :check_projects_payed_count

  def photographer_update
      photographer.update(:updated_at => Time.now)
  end

  def check_projects_payed_count
    if self.projects_payed_count == nil
      self.projects_payed_count = 0
    end
  end

end
