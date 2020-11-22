module Projects
  class AnalyzeProject
    include Interactor
    QUERY = <<-SQL
    select *from (select count(1) count_project, substring(g2j(start_time), 6, 2) p_month
    from projects
    where substring(g2j(start_time), 1, 4) = ? AND is_payed = ?
    group by substring(g2j(start_time), 6, 2)
  ) a order by p_month;
  SQL

    def call
      projects = Project.payed.find_by_sql([QUERY, context.year, context.is_payed])
      context.result = projects.map { |p| [Kadro::ConvertMonth.call(month: p.p_month).result, p.count_project] }
    end
  end
end
