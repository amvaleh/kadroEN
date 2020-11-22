class Api::V1::FreeTimesController < ApiController
  before_action :find_photographer, except: :available_hours
  before_action :find_project, exept: [:create , :index]
  skip_before_action :authenticate_token , except: [:create,:available_hours]
  respond_to :json
  include ApplicationHelper
  include Swagger::Docs::Methods


  swagger_controller :free_time, "Free Time Of Photographers"

  swagger_api :index do |api|
    summary "Get Photographer Free Time"
    Api::V1::FreeTimesController::free_time_index(api)
    response :accepted
    response :bad_request
  end

  swagger_api :create do |api|
    summary "Create Free Times For Photographer"
    Api::V1::FreeTimesController::free_time_create(api)
    response :accepted
    response :bad_request
  end

  swagger_api :available_hours do |api|
    summary "Get Photographer's Available Hours"
    Api::V1::FreeTimesController::free_time_available_hours(api)
    response :accepted
    response :bad_request
  end

  def self.free_time_index(api)
    api.param :query, "photographer_id", :integer, :required, "Photographer ID"
  end

  def self.free_time_create(api)
    api.param :header, "Authorization", :string, :required, "Authorization"
    api.param :form, "free_time", :string, :required, "package id"
    api.param :form, "photographer_id", :integer, :required, "Photographer ID"
  end

  def self.free_time_available_hours(api)
    api.param :header, "Authorization", :string, :required, "Authorization"
    api.param :form, "free_time[package_id]", :integer, :required, "Package ID"
    api.param :form, "free_time[date]", :string, :required, "Date & Time"
    api.param :form, "free_time[shoot_type]", :string, :required, "Shoot Type"
    api.param :form, "project_slug", :string, :required, "Project Slug"
  end



  def index
    @free_times = @photographer.free_times
    render json: @free_times.to_json, status: :accepted
  end

  def create
    if params[:free_time].present?
      day_number_log=nil
      @photographer.free_times.destroy_all
      params[:free_time].each do |item|
        free_time= @photographer.free_times.build(day:item[:day],start:item[:start].to_date,end:item[:end].to_date)
        unless free_time.save
          day_number_log=convert_persian_number_day(item[:day].to_i,true)
          break
        end
      end

      unless day_number_log.nil?
        render json: "ثبت رکورد شما در روز #{day_number_log} با مشکل مواجه شده است ، لطفاً ورودی های را بررسی نمایید",status: :bad_request
      else
        render json: true,status: :accepted
      end

    else
      render json:"برنامه زمانی دریافت نشد!",status: :bad_request
    end

  end

  def available_hours
    package = Package.find_by(:id => free_time_params[:package_id])
    duration = convert_package_duration_number(package.duration) # package duration
    # byebug
    # unless free_time_params[:date]
    #   render json: "مقدار تاریخ نامعتبر است".to_json, status: :bad_request
    #   return
    # end
    # shoot_type = free_time_params[:shoot_type]
    # date       = DateTime.parse(free_time_params[:date]).strftime("%Y-%m-%d").to_date
    # if duration == 0
    #   render json: "مقدار زمان انتخابی معتبر نیست".to_json, status: :bad_request
    #   return
    # end
    # week_day = helpers.convert_persian_number_day(date.to_date.to_pdate.strftime("%A"),false)
    # #Initialization
    # @available_hours = []
    # times            = []
    # times[0]         = date.to_time + 7.hour + 30.minutes #initial_time
    # 27.times do |n| # 28 time slots. every 30mins
    #   times[n+1] = times[n] + 30.minutes
    # end
    # @projects = Project.confirmed.where("date(start_time) = (?)", date )
    # #Available hours
    # @free_times = FreeTime.joins(:photographer => :expertises).where(:day => week_day , :photographers => {:approved=>true} , :expertises => {:shoot_type_id=>shoot_type , :approved=>true})
    # collision_free = true
    # times.each do |time|
    #   @free_times.each do |free_time|
    #     collision_free = true
    #     if time_in_range?(time.strftime("%H:%M"), (time+duration.hours).strftime("%H:%M"), free_time.start.to_formatted_s(:time).to_time.strftime("%H:%M"), free_time.end.to_formatted_s(:time).to_time.strftime("%H:%M"))
    #       @projects.each do |project| #Check reservations
    #         project_start = project.start_time.to_time
    #         if project.photographer_id==free_time.photographer_id && times_overlap?(time.strftime("%H:%M"), (time+duration.hours).strftime("%H:%M"), (project_start - 59.minutes).strftime("%H:%M") , (project_start + helpers.order_to_duration(project.package.order) + 59.minutes).strftime("%H:%M"))
    #           collision_free = false
    #           break
    #         end
    #       end
    #       if collision_free
    #         @available_hours << time.to_formatted_s(:time) #shrink to only time
    #         break
    #       end
    #     end
    #   end
    # end
    # #Returns back list of available times
    unless free_time_params[:date]
      render json: "مقدار تاریخ نامعتبر است".to_json, status: :bad_request
    end
    shoot_type = free_time_params[:shoot_type]
    date = DateTime.parse(free_time_params[:date]).strftime("%Y-%m-%d").to_date
    if duration == 0
      render json: "مقدار زمان انتخابی معتبر نیست".to_json, status: :bad_request
    end
    week_day = helpers.convert_persian_number_day(date.to_date.to_pdate.strftime("%A"),false)
    #Initialization
    morning = []
    afternoon = []
    evening = []
    times = []
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
              if times_overlap?(time.strftime("%H:%M"), (time+duration.hours).strftime("%H:%M"), (project_start - 59.minutes).strftime("%H:%M") , (project_start + helpers.order_to_duration(project.package.order) + 59.minutes).strftime("%H:%M"))
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
        location = free_time.photographer.location
        if location.distance_to([@project.address.lattitude.to_f,@project.address.longtitude.to_f]) < distance
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
    render json: result.to_json, status: :accepted
  end



  private
  def find_photographer
    if params[:photographer_id].present?
      @photographer = Photographer.find(params[:photographer_id])
    else
      render json: "عکاس دریافت نشد",status: :bad_request
    end
  end

  def free_time_params
    params.require(:free_time).permit(:day,:start,:end,:package_id,:shoot_type,:date)
  end

  #Returns true if given time is in bound
  def time_in_range?(start_time, end_time, ph_free_start_time, ph_free_end_time)
    start_time.between?(ph_free_start_time, ph_free_end_time) && end_time.between?(ph_free_start_time, ph_free_end_time)
  end
  #Returns true if times have no overlap
  def times_overlap?(start_time, end_time, start_bound, end_bound)
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


end
