module Projects
  class CountProjectWithCallStatus
    include Interactor

    QUERY = <<-SQL
          select *
          from projects p
          where p.created_at >= ? and p.created_at <= ? and p.call_status_id is not null
            SQL

    def call
      context.count = Project.find_by_sql([QUERY, context.start_date, context.end_date]).count
    end
  end
end
