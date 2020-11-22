module Projects
  class ProjectsCountPerDay
    include Interactor

    def call
      p = Project.confirmed_with_date(context.start_date, context.end_date).group_by_day(:created_at, range: context.start_date..context.end_date).count.map { |p| [p.first.to_date.to_pdate.to_s[5..12], p.second] }
      p.pop
      context.result = p
    end
  end
end
