class ReasonForReject < ApplicationRecord
  has_many :project_candidates
  scope :display, -> {
    where(:display => true)
  }
end
