module ShootLocations
  class FindDirectShootType
    include Interactor

    QUERY = <<-SQL
select sh.*
from shoot_types sh
inner join shoot_type_locations shl on shl.shoot_type_id = sh.id
inner join shoot_locations l on l.id = shl.shoot_location_id
where l.slug = ?
      SQL

    def call
      if context.shoot_location.shoot_type_locations.any?
        context.shoot_types = ShootType.find_by_sql([QUERY, context.shoot_location.slug])
      elsif context.shoot_location.is_studio && context.shoot_location.photographer.present? && context.shoot_location.shoot_location_type.title = "آتلیه" && context.shoot_location.approved
        context.shoot_types = ShootType.joins(:expertises => :photographer).where(:is_active => true, :expertises => { :approved => true }, :photographers => { :id => context.shoot_location.photographer.id, :approved => true })
      end
    end
  end
end
