module AhoyAnalyze
  class VisitsCountPerDayWithUtmSource
    include Interactor

    def call
      p = Ahoy::Visit.visits_with_date_and_utm_source(context.start_date, context.end_date, context.utm_source).group_by_day(:started_at, range: context.start_date..context.end_date).count.map { |p| [p.first.to_date.to_pdate.to_s[5..12], p.second] }
      p.pop
      context.result = p
    end
  end
end
