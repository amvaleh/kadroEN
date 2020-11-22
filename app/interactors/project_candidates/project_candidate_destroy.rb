module ProjectCandidates
  class ProjectCandidateDestroy
    include Interactor

    def call
      if context.status_id.present?
        delete_item = ProjectCandidate.where(project_id: context.project.id, project_candidate_status_id: context.status_id).destroy_all
      elsif context.id.present?
        delete_item = ProjectCandidate.where(id: context.id).destroy_all
      else
        delete_item = ProjectCandidate.where(project_id: context.project.id).destroy_all
      end
    end
  end
end
