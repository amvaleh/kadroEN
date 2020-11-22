module Projects
  class AnalyzeSumTotal
    include Interactor
    QUERY = <<-SQL
    select *from (select sum(cast(total AS float)) sum_total, substring(g2j(start_time), 6, 2) p_month
    from projects p
    INNER JOIN receipts r ON p.receipt_id=r.id
    where substring(g2j(start_time), 1, 4) = ? AND is_payed = ?
    group by substring(g2j(start_time), 6, 2)
  ) a order by p_month;
  SQL
  def call
    projects = Project.payed.find_by_sql([QUERY,context.year,context.is_payed])
    context.result = projects.map{|p| [Kadro::ConvertMonth.call(month: p.p_month).result , p.sum_total]}
  end
end
end
