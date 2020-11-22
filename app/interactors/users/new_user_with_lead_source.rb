module Users
  class NewUserWithLeadSource
    include Interactor
    QUERY = <<-SQL
      select *
      from users pp
      where pp.created_at >= ? and pp.created_at <= ? and pp.lead_source_id = ?
        SQL

    def call
      context.count = Project.find_by_sql([QUERY, context.start_date, context.end_date, context.lead_source_id]).count
    end
  end
end
