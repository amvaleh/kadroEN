module Projects
  class ConfirmedCountProjectsWithAdmin
    include Interactor

    QUERY = <<-SQL
        select *
        from projects p
        where p.confirmed = true and p.admin_user_id is not null and p.is_payed_at >= ? and p.is_payed_at <= ?
          SQL

    def call
      context.count = Project.find_by_sql([QUERY, context.start_date, context.end_date]).count
    end
  end
end
