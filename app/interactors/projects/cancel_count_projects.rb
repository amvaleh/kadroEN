module Projects
  class CancelCountProjects
    include Interactor

    QUERY = <<-SQL
            select *
            from projects p
            where p.reserve_step_id = ? and p.created_at >= ? and p.created_at <= ?
              SQL

    def call
      step_id = ReserveStep.find_by(name: "canseled_project").id
      context.count = Project.find_by_sql([QUERY, step_id, context.start_date, context.end_date]).count
    end
  end
end
