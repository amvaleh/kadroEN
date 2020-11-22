module ShootTypes
  class ShootTypeSortForPhotographer
    include Interactor

    QUERY = <<-SQL
    select sh.*
    from shoot_types sh
    left join
    (select e.id as expertise_id , e.shoot_type_id , concat('true') as present , e.order
    from expertises e
    left join photographers ph on ph.id = e.photographer_id
    where ph.id = ?) e on e.shoot_type_id = sh.id
    where sh.is_active = true
		ORDER BY e.order
    SQL

    def call
      context.shoot_types = ShootType.find_by_sql([QUERY, context.photographer.id])
    end
  end
end
