module ProjectCandidates
  class ProjectCandidateToFreeTimes
    include Interactor

    def call
      free_times = []
      context.project_candidates.where(project_candidate_status_id: ProjectCandidateStatus.find_by_title("elected").id).each do |project_candidate|
        ph_free_times = project_candidate.photographer.free_times.where(day: context.week_day)
        ph_free_times.each do |ph_free_time|
          free_times << ph_free_time
        end
      end
      context.free_times = free_times
    end
  end
end
