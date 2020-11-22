module ProjectCandidates
  class ProjectCandidateCreateForKnownPhotographer
    include Interactor

    def call
      rational_distance = context.project.package.rational_distance
      waiting_status_id = ProjectCandidateStatus.find_by_title("waiting").id
      extra_transportation = Setting.find_by_var("extra_transportation").value.to_i
      photographer = context.data
      project_candidates = ProjectCandidate.where(project_id: context.project.id)
      distance = photographer.location.distance_to([context.project.address.lattitude.to_f,context.project.address.longtitude.to_f])
      if (distance - rational_distance) > 0
        price = ((distance - rational_distance) * extra_transportation).round
        if price < 5000
          price = 5000
        else
          price = (price / 100).to_i
          price = price * 100
        end
      else
        price = 0
      end
      priority = project_candidates.count + 1
      project_candidate = ProjectCandidate.new(project_id: context.project.id, photographer_id: photographer.id, project_candidate_status_id: waiting_status_id, distance: distance, price: price, priority: priority )
      project_candidate.save
      context.project_candidate = project_candidate
    end
  end
end
