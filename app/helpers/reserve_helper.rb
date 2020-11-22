module ReserveHelper



  def available_hours( duration, date, shoot_type )
    duration = duration.to_f # package duration
    unless date
      # render json: "مقدار تاریخ نامعتبر است".to_json, status: :bad_request
      return "مقدار تاریخ نامعتبر است"
    end
    date = DateTime.parse(date).strftime("%Y-%m-%d").to_date
    if duration == 0
      # render json: "مقدار زمان انتخابی معتبر نیست".to_json, status: :bad_request
      return "مقدار زمان انتخابی معتبر نیست"
    end
    week_day = helpers.convert_persian_number_day(date.to_date.to_pdate.strftime("%A"),false)
    #Initialization
    morning = []
    afternoon = []
    evening = []
    times            = []
    times[0]         = date.to_time + 7.hour + 30.minutes #initial_time
    27.times do |n| # 28 time slots. every 30mins
      times[n+1] = times[n] + 30.minutes
    end
    if @project.photographer.present?
      @project.photographer.expertises.each do |expertise|
        if @project.shoot_type == expertise.shoot_type
          @conditional = true
        end
      end

    end
    if @conditional
      @projectss = Project.confirmed.where("date(start_time) = (?)" , date)
      @projects = @projectss.where(:photographer => @project.photographer)
      @free_times = FreeTime.where(photographer: @project.photographer , day: week_day)
      times.each do |time|
        @free_times.each do |free_time|
          collision_free = true
          if time_in_range?(time.strftime("%H:%M"), (time+duration.hours).strftime("%H:%M"), free_time.start.to_formatted_s(:time).to_time.strftime("%H:%M"), free_time.end.to_formatted_s(:time).to_time.strftime("%H:%M"))
            @projects.each do |project| #Check reservations
              project_start = project.start_time.to_time
              if times_overlap?(time.strftime("%H:%M"), (time+duration.hours).strftime("%H:%M"), (project_start - 59.minutes).strftime("%H:%M") , (project_start + helpers.convert_package_duration_number(project.package.duration).hour + 59.minutes).strftime("%H:%M"))
                collision_free = false
                break
              end
            end
            if collision_free
              if time_range_day(time.to_formatted_s(:time)) == 1
                morning << time.to_formatted_s(:time).tr(':0123456789',':۰۱۲۳۴۵۶۷۸۹')
              elsif time_range_day(time.to_formatted_s(:time)) == 2
                afternoon << time.to_formatted_s(:time).tr(':0123456789',':۰۱۲۳۴۵۶۷۸۹')
              else
                evening << time.to_formatted_s(:time).tr(':0123456789',':۰۱۲۳۴۵۶۷۸۹')
              end
              # @available_hours << time.to_formatted_s(:time) #shrink to only time
              break
            end
          end
        end
      end

    else
      @projects = Project.confirmed.where("date(start_time) = (?)", date )
      #Available hours
      @basic_free_times = FreeTime.joins(:photographer => :expertises).where(:day => week_day , :photographers => {:approved=>true} , :expertises => {:shoot_type_id=>shoot_type , :approved=>true})
      @free_times = []
      distance = Setting.find_by_var("distance").value.to_i
      @basic_free_times.each do |free_time|
        if free_time.photographer.location.distance_to([params[:lattitude],params[:longtitude]]) < distance
          @free_times << free_time
        end
      end
      collision_free = true
      times.each do |time|
        @free_times.each do |free_time|
          collision_free = true
          if time_in_range?(time.strftime("%H:%M"), (time+duration.hours).strftime("%H:%M"), free_time.start.to_formatted_s(:time).to_time.strftime("%H:%M"), free_time.end.to_formatted_s(:time).to_time.strftime("%H:%M"))
            @projects.each do |project| #Check reservations
              project_start = project.start_time.to_time
              if project.photographer_id==free_time.photographer_id && times_overlap?(time.strftime("%H:%M"), (time+duration.hours).strftime("%H:%M"), (project_start - 59.minutes).strftime("%H:%M") , (project_start + helpers.order_to_duration(project.package.order) + 59.minutes).strftime("%H:%M"))
                collision_free = false
                break
              end
            end
            if collision_free
              if time_range_day(time.to_formatted_s(:time)) == 1
                morning << time.to_formatted_s(:time).tr(':0123456789',':۰۱۲۳۴۵۶۷۸۹')
              elsif time_range_day(time.to_formatted_s(:time)) == 2
                afternoon << time.to_formatted_s(:time).tr(':0123456789',':۰۱۲۳۴۵۶۷۸۹')
              else
                evening << time.to_formatted_s(:time).tr(':0123456789',':۰۱۲۳۴۵۶۷۸۹')
              end
              # @available_hours << time.to_formatted_s(:time) #shrink to only time
              break
            end
          end
        end
      end
    end
    # morning2 = morning.each{|str| str.tr!(':0123456789' , ':۰١۲۳۴۵۶۷۸۹')}
    # morning2.each do |mor2|
    #   resultss.push(StartHour.find_by(:title => mor2 , :week_day => week_day))
    # end
    if !morning.any? && !afternoon.any? && !evening.any?
      result = []
      result = { response: 'nok' }
    else
      result = []
      result = { response: 'ok' , result: [
        {time_name: 'صبح' , times:  morning },
        {time_name: 'ظهر' , times:  afternoon },
        {time_name: 'شب' , times: evening }
      ]
    }
  end
  return result
end


# Repeat in api/v1/free_times
#Returns true if given time is in bound
def time_in_range?(start_time, end_time, ph_free_start_time, ph_free_end_time)
  start_time.between?(ph_free_start_time, ph_free_end_time) && end_time.between?(ph_free_start_time, ph_free_end_time)
end
#Returns true if times have no overlap
def times_overlap?(start_time, end_time, start_bound, end_bound)
Rails.logger.info start_time
Rails.logger.info end_time
Rails.logger.info start_bound 
Rails.logger.info end_bound
  start_time.between?(start_bound, end_bound) || end_time.between?(start_bound, end_bound) || start_bound.between?(start_time , end_time) || end_bound.between?(start_time , end_time)
end

def time_range_day(time)
  if (time.to_i < 12)
    return 1
  elsif (time.to_i > 11 && time.to_i < 16 )
    return 2
  else
    return 3
  end
end


def available_photographer(project_slug , date)
  @project = Project.find_by(:slug => project_slug)
  duration = helpers.convert_package_duration_number(Project.find_by(id: @project.id).package.duration) # package duration
  unless date
    # render json: "مقدار تاریخ نامعتبر است".to_json, status: :bad_request
    return "مقدار تاریخ نامعتبر است"
  end
  shoot_type = Project.find_by(id: @project.id).shoot_type.id
  # date       = DateTime.parse(date1)
  # Project.where(id: @project.id).first.update_attributes(start_time: date ,start_date: date)
  if duration == 0
    # render json: "مقدار زمان انتخابی معتبر نیست".to_json, status: :bad_request
    return "مقدار زمان انتخابی معتبر نیست"
  end
  week_day = helpers.convert_persian_number_day(date.to_date.to_pdate.strftime("%A"),false)
  #Initialization
  @available_photographer = []
  # times            = []
  # times[0]         = date.to_time #initial_time
  time = date.to_time

  @projects = Project.confirmed.where("date(start_time) = (?)", date.strftime("%Y-%m-%d").to_date )
  #Available hours
  @free_times = FreeTime.joins(:photographer => :expertises).where(:day => week_day , :photographers => {:approved=>true} , :expertises => {:shoot_type_id=>shoot_type , :approved=>true})
  collision_free = true
  @free_times.each do |free_time|
    collision_free = true
    if time_in_range?(time.strftime("%H:%M"), (time+duration.hours).strftime("%H:%M"), free_time.start.to_formatted_s(:time).to_time.strftime("%H:%M"), free_time.end.to_formatted_s(:time).to_time.strftime("%H:%M"))
      @projects.each do |project| #Check reservations
        project_start = project.start_time.to_time
        if project.photographer_id==free_time.photographer_id && times_overlap?(time.strftime("%H:%M"), (time+duration.hours).strftime("%H:%M"), (project_start - 59.minutes).strftime("%H:%M") , (project_start + helpers.order_to_duration(project.package.order) + 59.minutes).strftime("%H:%M"))
          collision_free = false
          break
        end
      end
      if collision_free
        @available_photographer << free_time.photographer
      end
    end
  end
  @locations = []
  @available_photographer.each do |photographer|
    @locations << photographer.location
  end
  @final_photographer = []
  distance = Setting.find_by_var("distance").value.to_i
  @locations.each do |location|
    if location.distance_to([@project.address.lattitude,@project.address.longtitude]) < distance
      @final_photographer << location.photographer
    end
  end
  #Returns back list of available Photographers
  return @final_photographer.shuffle
end

end
