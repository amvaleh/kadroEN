module Projects
  class FindProjectBySlug
    include Interactor

    QUERY = <<-SQL
      select *
      from projects u
      where u.slug like ?
      limit 10
      SQL

    def call
      context.projects = Project.find_by_sql([QUERY, context.slug + "%"])
    end
  end
end
