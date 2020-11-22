module LeadSources
  class CanceledCountProjects
    include Interactor

    QUERY = <<-SQL
      select *
      from projects p
      where p.reserve_step_id = ? and p.lead_source_id = ? and p.is_payed_at >= ? and p.is_payed_at <= ?
        SQL

    def call
      step_id = ReserveStep.find_by(name: "canseled_project").id
      context.count = Project.find_by_sql([QUERY, step_id, context.lead_source_id, context.start_date, context.end_date]).count
    end
  end
end
