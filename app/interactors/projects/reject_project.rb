module Projects
  class RejectProject
    include Interactor

    def call
      project = Project.find(context.project_id)
      candidate = ProjectCandidate.find(context.project_candidate_id)

      project.set_reserve_step("care")
      project.confirmed = false

      candidate.project_candidate_status_id = ProjectCandidateStatus.find_by(:title => "rejected").id
      candidate.reason_for_reject_id = context.reason_for_reject_id
      candidate.save

      if project.change_loop_times.nil?
        project.change_loop_times = 0
      end

      if project.change_loop_times < 2
        Users::SmsChangePhotographer.call(project_id: project.id, reason_for_reject_id: candidate.reason_for_reject_id)
      end
      project.change_loop_times = project.change_loop_times + 1
      project.save
    end
  end
end
