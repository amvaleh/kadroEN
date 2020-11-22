module Projects
  class ActivePhotographer
    include Interactor
    QUERY = <<-SQL
    select count(1) count
    from 
    (select DISTINCT(pp.photographer_id)
    from projects pp
    where pp.is_payed_at >= ? and pp.is_payed_at <= ? and pp.confirmed = true) p
        SQL

    def call
      count = Project.find_by_sql([QUERY, context.start_date, context.end_date])
      context.total = count.map { |p| p.count }.first.to_i
    end
  end
end
