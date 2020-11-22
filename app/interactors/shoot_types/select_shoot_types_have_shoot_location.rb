module ShootTypes
  class SelectShootTypesHaveShootLocation
    include Interactor

    QUERY = <<-SQL
    select sh.*
    from shoot_types sh
    inner join shoot_type_locations shl on sh.id = shl.shoot_type_id
    where shl.id is not null
    SQL

    def call
      context.shoot_types = ShootType.find_by_sql([QUERY]).uniq
    end
  end
end
