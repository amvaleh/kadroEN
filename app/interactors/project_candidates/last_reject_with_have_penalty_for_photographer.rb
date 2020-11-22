module ProjectCandidates
  class LastRejectWithHavePenaltyForPhotographer
    include Interactor

    QUERY = <<-SQL
  select pc.*
  from project_candidates pc
  left join project_candidate_statuses pcs on pcs.id = pc.project_candidate_status_id
  left join reason_for_rejects rr on rr.id = pc.reason_for_reject_id
  where pc.photographer_id = ? and pcs.title = 'rejected' and rr.have_penalty = true
  ORDER BY pc.created_at desc
  limit ?
      SQL

    def call
      context.project_candidates = ProjectCandidate.find_by_sql([QUERY, context.photographer_id, context.limit])
    end
  end
end
