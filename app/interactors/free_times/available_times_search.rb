module FreeTimes
  class AvailableTimesSearch
    include Interactor
    include ApplicationHelper

    def call
      duration = convert_package_duration_number(context.project.package.duration)
      morning = []
      afternoon = []
      evening = []
      times = []
      photographers = []
      times[0] = context.date.to_time + 6.hour + 30.minutes #initial_time
      31.times do |n| # 28 time slots. every 30mins
        times[n + 1] = times[n] + 30.minutes
      end
      if context.data.reservation?
        projectss = Project.confirmed.where("date(start_time) = (?)", context.date)
        projects = @projectss.where(:photographer => context.project.photographer)
      else
        projects = Project.confirmed.where("date(start_time) = (?)", context.date)
      end
      times.each do |time|
        context.data.free_times.each do |free_time|
          collision_free = true
          tin = time_in_range?(time.strftime("%H:%M"), (time + duration.hours).strftime("%H:%M"), free_time.start.to_formatted_s(:time).to_time.strftime("%H:%M"), free_time.end.to_formatted_s(:time).to_time.strftime("%H:%M"))
          if tin
            projects.each do |project| #Check reservations
              project_start = project.start_time.to_time
              if project.photographer_id == free_time.photographer_id && times_overlap?(time.strftime("%H:%M"), (time + duration.hours).strftime("%H:%M"), (project_start - 59.minutes).strftime("%H:%M"), (project_start + order_to_duration(project.package.order) + 59.minutes).strftime("%H:%M"))
                collision_free = false
                break
              end
            end
            if collision_free
              photographers << free_time.photographer
              if time_range_day(time.to_formatted_s(:time)) == 1
                morning << time.to_formatted_s(:time).tr(":0123456789", ":۰۱۲۳۴۵۶۷۸۹")
              elsif time_range_day(time.to_formatted_s(:time)) == 2
                afternoon << time.to_formatted_s(:time).tr(":0123456789", ":۰۱۲۳۴۵۶۷۸۹")
              else
                evening << time.to_formatted_s(:time).tr(":0123456789", ":۰۱۲۳۴۵۶۷۸۹")
              end
              # @available_hours << time.to_formatted_s(:time) #shrink to only time
              break
            end
          end
        end
      end
      context.morning = morning
      context.afternoon = afternoon
      context.evening = evening
      context.photographers = photographers
    end

    private

    def time_in_range?(start_time, end_time, ph_free_start_time, ph_free_end_time)
      start_time.between?(ph_free_start_time, ph_free_end_time) && end_time.between?(ph_free_start_time, ph_free_end_time)
    end

    def times_overlap?(start_time, end_time, start_bound, end_bound)
      start_time.between?(start_bound, end_bound) || end_time.between?(start_bound, end_bound) || start_bound.between?(start_time, end_time) || end_bound.between?(start_time, end_time)
    end

    def time_range_day(time)
      if (time.to_i < 12)
        return 1
      elsif (time.to_i > 11 && time.to_i < 16)
        return 2
      else
        return 3
      end
    end
  end
end
