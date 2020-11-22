module ProjectCandidates
  class ProjectCandidateSearch
    include Interactor

    def call
      context.project_candidates = ProjectCandidate.where(project_id: context.project, project_candidate_status_id: ProjectCandidateStatus.find_by_title("elected").id )
    end
  end
end
