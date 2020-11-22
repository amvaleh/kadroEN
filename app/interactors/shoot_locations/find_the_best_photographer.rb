module ShootLocations
  class FindTheBestPhotographer
    include Interactor

    QUERY = <<-SQL
WITH 
	latitude as ( values (?)),
	longitude as ( values (?))
select DISTINCT ph.* , concat(|/((((table latitude)-l.working_lat)^2)+(((table longitude)-l.working_long)^2))) as distance
from photographers ph
left join locations l on l.id = ph.location_id
left join expertises e on e.photographer_id = ph.id
left join shoot_types sh on sh.id = e.shoot_type_id
left join (
  select p.id , sum(f.end - f.start) as total
  from photographers p
  right join free_times f on f.photographer_id = p.id
  group by p.id
) gg on gg.id = ph.id
where sh.id in (?) and gg.total > '10:00:00'
AND
ph.approved = true
ORDER BY distance
limit 5
    SQL

    def call
      if !context.shoot_type_ids.present?
        context.shoot_type_ids = ShootType.active.map(&:id.to_proc)
      end
      context.photographers = Photographer.find_by_sql([QUERY, context.latitude, context.longitude, context.shoot_type_ids])
    end
  end
end
