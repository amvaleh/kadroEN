module ProjectCandidates
  class ProjectAlternativeCandidates
    include Interactor

    def call
      project = Project.find(context.project_id)
      context.photographers = Photographer.joins(project_candidates: :project_candidate_status)
                           .select('photographers.*, project_candidates.price, project_candidates.priority')
                           .where('project_candidates.project_id = ? and project_candidate_statuses.title != ?', project.id, "rejected")
                           .order('priority asc')
    end
  end
end
