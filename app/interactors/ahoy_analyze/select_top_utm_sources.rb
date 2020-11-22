module AhoyAnalyze
  class SelectTopUtmSources
    include Interactor

    QUERY = <<-SQL

        select count(a.utm_source), a.utm_source as source
        from ahoy_visits a
        where a.started_at >= ? and a.started_at <= ? and a.utm_source is not null
        GROUP BY a.utm_source
        ORDER BY count desc
        limit ?
  
        SQL

    def call
      context.utm_sources = LeadSource.find_by_sql([QUERY, context.start_date, context.end_date, context.limit]).map { |n| n.source }
    end
  end
end
