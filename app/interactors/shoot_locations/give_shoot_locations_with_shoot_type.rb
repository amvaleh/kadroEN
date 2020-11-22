module ShootLocations
  class GiveShootLocationsWithShootType
    include Interactor

    QUERY = <<-SQL
select sl.*
from shoot_locations sl
left join shoot_type_locations stl on stl.shoot_location_id = sl.id
left join shoot_types sh on sh.id = stl.shoot_type_id
where sl.is_studio = false and sl.approved = true and sh.id = ?
    SQL

    def call
      context.shoot_locations = ShootLocation.find_by_sql([QUERY, context.shoot_type_id])
    end
  end
end
