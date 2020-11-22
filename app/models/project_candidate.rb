class ProjectCandidate < ApplicationRecord
  belongs_to :project
  belongs_to :photographer
  belongs_to :project_candidate_status
  belongs_to :reason_for_reject

  before_save :check_step

  def check_step
    if project_candidate_status_id_changed?
      # if status is waiting
      if project_candidate_status_id == 2
          self.assigned_at = Time.now
      end
    end
  end


  scope :payed, -> { joins(:project).where("projects.is_payed = true") }
  scope :confirmed, -> { joins(:project).where("projects.confirmed = true") }
  scope :is_payed, -> { joins(:project).where("projects.is_payed = true") }


end
