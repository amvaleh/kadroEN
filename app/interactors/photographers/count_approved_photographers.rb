module Photographers
  class CountApprovedPhotographers
    include Interactor
    QUERY = <<-SQL
    select count(1) count
    from 
    (select DISTINCT(pp.id)
    from photographers pp
    where pp.approved_at > ? and pp.approved_at < ? and pp.approved = true) p
      SQL

    def call
      ph = Photographer.find_by_sql([QUERY, context.start_date, context.end_date])
      context.total = ph.map { |p| p.count }.first.to_i
    end
  end
end
