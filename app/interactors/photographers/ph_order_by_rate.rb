module Photographers
  class PhOrderByRate
    include Interactor
    QUERY = <<-SQL
    select *
from photographers p
       inner join (
  select pg.id, avg(fb.arate) arate, avg(fb.qrate) qrate
  from photographers pg
         left join projects p on p.photographer_id = pg.id
         left join feed_backs fb on fb.project_id = p.id
  group by pg.id) a on a.id = p.id and p.approved = true
order by (a.arate + a.qrate) DESC NULLS last;
    SQL

    def call
      context.photographers = Photographer.find_by_sql([QUERY])
    end
  end
end