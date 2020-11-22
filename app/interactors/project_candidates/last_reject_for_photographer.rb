module ProjectCandidates
  class LastRejectForPhotographer
    include Interactor

    QUERY = <<-SQL
select pc.*
from project_candidates pc
left join project_candidate_statuses pcs on pcs.id = pc.project_candidate_status_id
where pc.photographer_id = ? and pcs.title = 'rejected'
ORDER BY pc.created_at desc
limit ?
    SQL

    def call
      context.project_candidates = ProjectCandidate.find_by_sql([QUERY,context.photographer_id, context.limit])
    end
  end
end
