class ProjectCandidateForm < Reform::Form
  property :project_id
  property :photographer_id
  property :status
  property :priority
  property :price

  validates :project_id, presence: true
  validates :photographer_id, presence: true
end
