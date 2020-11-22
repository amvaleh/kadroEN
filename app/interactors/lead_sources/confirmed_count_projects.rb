module LeadSources
  class ConfirmedCountProjects
    include Interactor

    QUERY = <<-SQL
    select *
    from projects p
    where p.confirmed = true and p.lead_source_id = ? and p.is_payed_at >= ? and p.is_payed_at <= ?
      SQL

    def call
      context.count = Project.find_by_sql([QUERY, context.lead_source_id, context.start_date, context.end_date]).count
    end
  end
end
