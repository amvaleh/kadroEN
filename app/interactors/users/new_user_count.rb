module Users
  class NewUserCount
    include Interactor
    QUERY = <<-SQL
        select *
        from users pp
        where pp.created_at >= ? and pp.created_at <= ?
          SQL

    def call
      context.count = Project.find_by_sql([QUERY, context.start_date, context.end_date]).count
    end
  end
end
