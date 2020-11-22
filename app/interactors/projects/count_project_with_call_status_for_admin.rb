module Projects
  class CountProjectWithCallStatusForAdmin
    include Interactor

    QUERY = <<-SQL
        select *
        from projects p
        where p.admin_user_id = ? and p.created_at >= ? and p.created_at <= ? and p.call_status_id is not null
          SQL

    def call
      context.count = Project.find_by_sql([QUERY, context.admin_user_id, context.start_date, context.end_date]).count
    end
  end
end
