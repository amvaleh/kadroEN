module Projects
  class CalculatePenaltyForCancel
    include Interactor

    def call
      project = Project.find(context.project_id)
      project_candidate = ProjectCandidate.find(context.project_candidate_id)
      reason_for_reject = ReasonForReject.find(context.reason_for_reject_id)
      if reason_for_reject.have_penalty
        last_reject = ProjectCandidates::LastRejectWithHavePenaltyForPhotographer.call(photographer_id: project.photographer_id, limit: 1)
        if last_reject.project_candidates.any? and (last_reject.project_candidates.first.assigned_at.to_time + 30.days) >= Time.now
          value = Setting.find_by_var("percent_for_reject_penalty").value.to_i
          price = -(project.receipt.ph_payment.to_f * (value.to_f / 100))
          ph_payment = PhotographerPayment.new(photographer_id: project.photographer.id, project_id: project.id, price: price, payment_type: 11, status: 2)
          ph_payment.save
          context.ph_payment = ph_payment
        end
      end
    end
  end
end
