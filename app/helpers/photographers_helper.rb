module PhotographersHelper


  def resource_name
    :photographer
  end

  def resource
    @resource ||= Photographer.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:photographer]
  end

  def free_times_table (photographer)
    if photographer.free_times.present?
      @free_times = photographer.free_times.sort_by {|x| [x.day] }
      @data = []
      @week_days = [1,2,3,4,5,6,7]
      @free_times.each do |free_time|
        @week_days.each do |week_day|
          if free_time.day > week_day
            start_time = free_time.start.strftime("07:00").to_time
            end_time = free_time.start.strftime("07:00").to_time
            day = convert_persian_number_day(week_day,true)
            @data.push [day ,start_time ,end_time ]
          elsif free_time.day == week_day
            start_time = free_time.start.strftime("%H:%M").to_time
            end_time = free_time.end.strftime("%H:%M").to_time
            day = convert_persian_number_day(free_time.day,true)
            @data.push [day , start_time , end_time]
          else
            start_time = free_time.start.strftime("24:00").to_time
            end_time = free_time.start.strftime("24:00").to_time
            day = convert_persian_number_day(week_day,true)
            @data.push [day ,start_time ,end_time ]
          end
        end
      end
      return  @data
    end
  end


  #
  # def next_photographer_path
  #   photographer = current_photographer
  #   case photographer.join_step_id
  #   when 0 # not joined yet
  #     new_photographer_registration_path
  #   when 1 # basic info completed
  #
  #   when 2 # equipments completed
  #   when 3 # experience completed
  #   when 4 # portfolio completed
  #   when 5 # accepted
  #   when 6 # active
  #   end
  #
  #
  # end


end
