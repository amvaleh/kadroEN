module LeadSources
  class SelectTopLeadSource
    include Interactor

    QUERY = <<-SQL
select l.* , CASE WHEN i.count is null THEN '0' ELSE i.count END AS count
from lead_sources l
full join 
(select lead_source_id , count(p.id) as count
from projects p
where p.confirmed = true and p.is_payed_at >= ? and p.is_payed_at <= ?
GROUP BY p.lead_source_id HAVING p.lead_source_id is not null
ORDER BY count desc
limit ?) i on i.lead_source_id = l.id
where count > 0
ORDER BY count desc
    SQL

    def call
      context.lead_sources = LeadSource.find_by_sql([QUERY, context.start_date, context.end_date, context.limit])
    end
  end
end
