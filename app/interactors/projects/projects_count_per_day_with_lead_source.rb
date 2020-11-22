module Projects
  class ProjectsCountPerDayWithLeadSource
    include Interactor

    def call
      p = Project.confirmed_with_date_and_lead_source(context.start_date, context.end_date, context.lead_source_id).group_by_day(:created_at, range: context.start_date..context.end_date).count.map { |p| [p.first.to_date.to_pdate.to_s[5..12], p.second] }
      p.pop
      context.result = p
    end
  end
end
