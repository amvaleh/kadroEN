module Photographers
  class PhotographerSearchByTime
    include Interactor
    include ApplicationHelper
    include ReserveHelper

    def call
      duration = convert_package_duration_number(Project.find_by(id: context.project.id).package.duration) # package duration
      shoot_type = Project.find_by(id: context.project.id).shoot_type_id
      week_day = convert_persian_number_day(context.date.to_date.to_pdate.strftime("%A"), false)
      available_photographers = []
      time = context.date.to_time
      projects = Project.confirmed.where("date(start_time) = (?)", context.date.to_time.strftime("%Y-%m-%d").to_date)
      collision_free = true
      overlap_items = []
      context.data.free_times.each do |free_time|
        collision_free = true
        if time_in_range?(time.strftime("%H:%M"), (time + duration.hours).strftime("%H:%M"), free_time.start.to_formatted_s(:time).to_time.strftime("%H:%M"), free_time.end.to_formatted_s(:time).to_time.strftime("%H:%M"))
          projects.each do |project|
            project_start = project.start_time.to_time
            if project.photographer_id == free_time.photographer_id && times_overlap?(time.strftime("%H:%M"), (time + duration.hours).strftime("%H:%M"), (project_start - 59.minutes).strftime("%H:%M"), (project_start + order_to_duration(project.package.order) + 59.minutes).strftime("%H:%M"))
              collision_free = false
              overlap_items << ProjectCandidate.find_by(project_id: context.project.id, photographer_id: free_time.photographer.id)
              break
            end
          end
          if collision_free
            available_photographers << free_time.photographer
          end
        else
          overlap_items << ProjectCandidate.find_by(project_id: context.project.id, photographer_id: free_time.photographer.id)
        end
      end
      context.photographers = available_photographers.uniq
      context.overlap_items = overlap_items.uniq
    end

    private

    def time_in_range?(start_time, end_time, ph_free_start_time, ph_free_end_time)
      start_time.between?(ph_free_start_time, ph_free_end_time) && end_time.between?(ph_free_start_time, ph_free_end_time)
    end
  end
end
