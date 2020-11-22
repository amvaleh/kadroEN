module FreeTimes
  class FreeTimeSearch
    include Interactor
    include ApplicationHelper
    QUERY = <<-SQL
select f.*
from free_times f
left join photographers ph on ph.id = f.photographer_id
full join expertises e on e.photographer_id = ph.id
full join shoot_locations sh on sh.photographer_id = ph.id
where f.day = ? and ph.approved = true and e.shoot_type_id = ? and ph.has_studio =true and sh.is_studio =true and sh.approved = true and e.approved = true
    SQL

    def call
      shoot_type = context.project.shoot_type
      week_day = convert_persian_number_day(context.date.to_pdate.strftime("%A"),false)
      # conditional = false
      # if context.project.photographer.present?
      #   context.project.photographer.expertises.each do |expertise|
      #     if context.project.shoot_type == expertise.shoot_type
      #       conditional = true
      #     end
      #   end
      # end
      # if conditional
      #   context.free_times = FreeTime.where(photographer: context.project.photographer , day: week_day)
      #   context.reservation = true
      # else
      if context.photographer_uid.present?
        photographer = Photographer.find_by(uid:context.photographer_uid)
        context.free_times = photographer.free_times.where(:day => week_day)
      else
        if context.project.search_for_studio
          context.free_times = FreeTime.find_by_sql([QUERY, week_day, shoot_type.id])
        else
          context.free_times = FreeTime.joins(:photographer => :expertises).where(:day => week_day , :photographers => {:approved=>true} , :expertises => {:shoot_type_id=>shoot_type , :approved=>true})
        end

      end
      context.reservation = false
      # end
    end
  end
end
