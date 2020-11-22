module Maps
  class PhotographerFilter
    include Interactor
    QUERY = <<-SQL
    select p2.* from (select count(1) cnt, ph.id
    from photographers ph
    inner join projects p on p.photographer_id = ph.id
    where is_shooted = true
    group by ph.id) a
    left join photographers p2 on p2.id = a.id
    where cnt > ? AND p2.id in (?);
    SQL

    def call
      photographers = Photographer.all
      if context.data['shoot_type_id'].present?
        photographers = photographers.joins(:expertises => :shoot_type).where(:shoot_types => {:id => context.data['shoot_type_id']})
      end
      if context.data['city_id'].present?
        photographers = photographers.joins(:location => :city).where(:cities => {:id => context.data['city_id']})
      end
      if context.data['week_day_order'].present?
        photographers = photographers.joins(:free_times).where(:free_times => {:day => context.data['week_day_order']})
      end
      if context.data['q_rate'].present?
        photographers = photographers.where('qrate BETWEEN ? AND 6', context.data['q_rate'].to_i)
      end
      if context.data['a_rate'].present?
        photographers = photographers.where('arate BETWEEN ? AND 6', context.data['a_rate'].to_i)
      end
      if context.data['checked'].present?
        if context.data['checked'] == "true"
          checked_value = true
        elsif context.data['checked'] == "false"
          checked_value = false
        end
        photographers = photographers.where("coalesce(checked, false) = #{checked_value}")
      end
      if context.data['step'].present?
        photographers = photographers.where(join_step_id: context.data['step'].to_i)
      end
      if context.data['project_count'].present?
        photographer_ids = photographers.map {|p| p.id}
        photographers = Photographer.find_by_sql([QUERY, context.data['project_count'].to_i, photographer_ids])
      end
      context.photographers = photographers
    end
  end
end
