module Projects
  class ProjectsCountPerLeadSources
    include Interactor
    QUERY = <<-SQL
    select count(1) count_project, CASE WHEN l.title is null THEN 'Site' ELSE l.title END AS title
    from 
    (select *
    from projects pp
    where pp.is_payed_at >= ? and pp.is_payed_at <= ? and pp.confirmed = true and pp.lead_source_id in (?)) p
    left join lead_sources l on l.id = p.lead_source_id
    group by l.title
      SQL

    def call
      lead_sources = context.lead_sources.map { |l| l.id }
      lead_sources = LeadSource.find_by_sql([QUERY, context.start_date, context.end_date, lead_sources])
      nil_lead_sources = Project.confirmed_with_nil_lead_sources(context.start_date, context.end_date).count
      p = lead_sources.map { |p| [p.title, p.count_project] }
      p.push(["Site", nil_lead_sources])
      context.result = p
    end
  end
end
