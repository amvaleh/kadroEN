class Api::V1::PhotographersController < ApiController
  before_action :find_project, except: [:index, :photos, :create]
  skip_before_action :authenticate_token, except: [:portfolio]
  include Swagger::Docs::Methods
  include ReserveHelper
  respond_to :json

  swagger_controller :photographers, "Photographers"

  swagger_api :photos do |api|
    summary "Get Photographer's Photos"
    Api::V1::PhotographersController::photographer_photos(api)
    response :accepted
    response :bad_request
  end


  swagger_api :index do |api|
    summary "Get all Approved Photographers"
    Api::V1::PhotographersController::photographer_index(api)
    response :accepted
    response :bad_request
  end


  swagger_api :available_photographer do |api|
    summary "Available Photographer with Date"
    Api::V1::PhotographersController::available_photographer(api)
    response :accepted
    response :bad_request
  end

  swagger_api :create do |api|
    summary "Create new photographer"
    Api::V1::PhotographersController::create(api)
    response :accepted
    response :bad_request
  end


  def self.photographer_photos(api)
    api.param :query, "photographer_id", :string, :required, "Photographer ID"
    api.param :query, "shoot_type_id", :string, :required, "Shoot Type ID"

  end

  def self.photographer_index(api)
  end

  def self.available_photographer(api)
    api.param :form, "photographer[date]", :string, :required, "Date"
    api.param :form, "project_slug", :string, :required, "Project Slug"
  end

  def self.create(api)
    api.param :form, "photographer[first_name]", :string, :required, "First Name"
    api.param :form, "photographer[last_name]", :string, :required, "Last Name"
    api.param :form, "photographer[email]", :string, :required, "Email"
    api.param :form, "photographer[mobile_number]", :string, :required, "Mobile Number"
    api.param :form, "photographer[ideal_hours]", :integer, :required, "Ideal Hours"
    api.param :form, "photographer[static_number]", :string, :required, "Static Number"
    api.param :form, "photographer[password]", :string, :required, "Password"
    api.param :form, "photographer[parent_id]", :string, "Parent UID"

  end

  def create
    result = Photographers::PhotographerCreate.call(data: photographers_params)
    # if result.photographer_exist
    #   render json:{error:["شما با این شماره همراه عضو شده اید لطفا وارد سیستم شوید."]},status: :bad_request
    if result.success?
      photographer = ActiveModelSerializers::SerializableResource.new(
        result.photographer, each_serializer: PhotographerSerializer).as_json
        render json: Rw::SuccessResponse.call(object_name: 'photographer',
          response_object: photographer,
          additional_json: nil).result
          DeviseWorker.perform_async(result.photographer.id)
        else
          render json: {errors: result.errors}, status: :bad_request
        end
      end

      def filter_photographers
        @all_photographers = Photographers::PhOrderByRate.call.photographers
        @photographers = []
        if params[:shoot_type_id]
          @all_photographers.each do |photographer|
            if photographer.expertises.present?
              photographer.expertises.approved.each do |expertise|
                if expertise.shoot_type_id == params[:shoot_type_id].to_i
                  @photographers << photographer
                  break
                end
              end
            end
          end
        else
          @photographers = @all_photographers
        end
        @final_photographers = []
        if params[:city]
          @photographers.each do |photographer|
            if photographer.location.present?
              if photographer.location.city_name == params[:city]
                @final_photographers << photographer
              end
            end
          end
        else
          @final_photographers = @photographers
        end

        render json: {data: @final_photographers, success: true}, status: :accepted
      end


      def index
        if params[:shoot_type].present?
          shoot_type = ShootType.find(params[:shoot_type])
          @all_photographer = Photographer.joins(:expertises).where("expertises.shoot_type_id = ? and photographers.approved = ?", shoot_type.id, true).sort_by {|ph| [-ph.projects.checked_out.count,-ph.arate, -ph.qrate]}
          # @all_photographer = Photographer.joins(Expertise).where(:shoot_type=>shoot_type,approved: true)
          # @all_photographer = Photographer.approved.sort_by {|ph| [-ph.arate,-ph.qrate]}
        else
          @all_photographer = Photographer.approved.sort_by {|ph| [-ph.projects.checked_out.count,-ph.arate, -ph.qrate]}
        end
        @msg = []
        @all_photographer.first(12).each do |photographer|
          @shoot_types = []
          # @locations = []
          @lenzs = []
          @cameras = []
          # equipment = nil
          # equip_cameras = nil
          if photographer.equipment.present?
            photographer.equipment.cameras.each do |camera|
              @cameras << camera.display_name
            end
            photographer.equipment.lenzs.each do |lenz|
              @lenzs << lenz.display_name
            end
          end
          if photographer.expertises.present?
            photographer.expertises.approved.each do |expertise|
              @shoot_types << expertise.shoot_type.title
            end
          end
          if photographer.location.present? and photographer.location.city.present?
            @location = photographer.location.city.name
          else
            @location = "تهران"
          end
          @images = {:url => photographer.avatar.url.to_s, :thumb => photographer.avatar.thumb.to_s, :medium => photographer.avatar.medium.to_s, :large => photographer.avatar.large.to_s}
          # location_id = photographer.location_id
          # @locations << Location.where(:id => location_id)
          @msg << {:name => photographer.abbrv_name, :uid => photographer.uid, :expertise => @shoot_types, :imeges => @images, :rate => (photographer.arate + photographer.qrate) / 4, :camera => @cameras, :city => @location}
          # expertises = photographer.expertises.approved
          # @data << [ photographer.display_name , photographer.uid, @shoot_types , photographer.avatar , @cameras , @lenzs  , @locations]

          # Photographers::Analyze::MakeShootSuggestion.call(photographer_id: photographer.id, cookies: cookies)
        end
        # set_cookie
        render json: {data: @msg, success: true}, status: :accepted
      end

      #set visit time in cookie
      def set_cookie
        cookies[:visit] = {
          value: Time.now,
          expires: 5.minute.from_now
        }
      end


      def feed_backs
        photographer = Photographer.find_by(uid: params[:id])
        @feedbacks = FeedBack.joins(:project).where('photographer_id = ?', photographer.id)
        @is_good_feedback=nil
        @good_feedbacks = []
        @feedbacks.each do |p|
          fb = Hash.new
          if p.qrate > 8 and p.arate > 8
            @is_good_feedback = true
            if p.description.present?
              fb ["text"] = p.description
              fb ["quality"] = p.qrate
              fb ["service"] = p.arate
              fb ["user"] = p.project.user.display_name
              fb ["shoot_type"] = p.project.shoot_type.title
              fb ["start_time"] = p.project.start_time.to_date.to_pdate.strftime("%b %Y")
if p.project.package.present?
fb ["duration"] = p.project.package.order + p.project.extend_hours
else
fb ["duration"] = 2
end
              if p.project.gallery.present?
                fb ["photo_counts"] = p.project.gallery.frames.count
              end
              @good_feedbacks << fb
            end
          end
        end
        render json: {feed_backs: @good_feedbacks}
      end

      def user_comments
        @msg = []
        if params[:shoot_type].present?
          feed_backs = FeedBack.where('feed_backs.publishable = ? and arate > ? and qrate > ? and description != ?',true, 8, 8,'').joins(project: :shoot_type).where('shoot_types.id = ?', params[:shoot_type]).joins('left join users u on projects.user_id = u.id').last(40)
        else
          feed_backs = FeedBack.where('feed_backs.publishable = ? and arate > ? and qrate > ? and description != ?',true ,8, 8,'').joins(project: :shoot_type).joins('left join users u on projects.user_id = u.id').last(40)
        end

        feed_backs.each do |feed_back|
          @msg << {body: feed_back.description, shoot_type: feed_back.project.shoot_type.title,object:feed_back.project.photographer.abbrv_name, writer: feed_back.project.user.display_name.present? ? feed_back.project.user.display_name.split(' ')[0] : '',rate: ((feed_back.qrate+feed_back.arate)/2) }
        end

        render json: {data: @msg, success: true}, status: :accepted
      end

      def available_photographer
        duration = helpers.convert_package_duration_number(Project.find_by(id: @project.id).package.duration) # package duration
        unless photographers_params[:date]
          render json: "مقدار تاریخ نامعتبر است".to_json, status: :bad_request
          return
        end
        shoot_type = Project.find_by(id: @project.id).shoot_type_id
        date = photographers_params[:date]
        # project_hour = photographers_params[:date].to_time.strftime("%H:%M")
        @project.start_date = date.to_date
        # hour = project_hour.split(":").first
        # minute = project_hour.split(":").second
        @project.start_time = date.in_time_zone('Tehran').in_time_zone('UTC')
        # @project.start_time = DateTime.new(@project.start_date.year,@project.start_date.month,@project.start_date.day,hour.to_i,minute.to_i,0,'+0430')
        # date       = DateTime.parse(photographers_params[:date])
        # Project.where(id: @project.id).first.update_attributes(start_time: date ,start_date: date)
        @project.set_reserve_step("date")
        @project.save
        @project.user.create_activity :set_date_time, owner: @project.user, recipient: @project
        if duration == 0
          render json: "مقدار زمان انتخابی معتبر نیست".to_json, status: :bad_request
          return
        end
        week_day = helpers.convert_persian_number_day(date.to_date.to_pdate.strftime("%A"), false)
        #Initialization
        @available_photographer = []
        # times            = []
        # times[0]         = date.to_time #initial_time
        time = date.to_time
        @projects = Project.confirmed.where("date(start_time) = (?)", date.to_time.strftime("%Y-%m-%d").to_date)
        #Available hours
        @free_times = FreeTime.joins(:photographer => :expertises).where(:day => week_day, :photographers => {:approved => true}, :expertises => {:shoot_type_id => shoot_type, :approved => true})
        collision_free = true
        @free_times.each do |free_time|
          collision_free = true
          if time_in_range?(time.strftime("%H:%M"), (time + duration.hours).strftime("%H:%M"), free_time.start.to_formatted_s(:time).to_time.strftime("%H:%M"), free_time.end.to_formatted_s(:time).to_time.strftime("%H:%M"))
            @projects.each do |project| #Check reservations
              project_start = project.start_time.to_time
              if project.photographer_id == free_time.photographer_id && times_overlap?(time.strftime("%H:%M"), (time + duration.hours).strftime("%H:%M"), (project_start - 59.minutes).strftime("%H:%M"), (project_start + helpers.order_to_duration(project.package.order) + 59.minutes).strftime("%H:%M"))
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
          if location.distance_to([@project.address.lattitude, @project.address.longtitude]) < distance
            @final_photographer << location.photographer
          end
        end

        @final_photographer.each do |photographer|
          Photographers::Analyze::MakeShootSuggestion.call(photographer_id: photographer.id, project_id: @project.id, user_id: @project.user_id, cookies: cookies)
        end
        #set visit time in cookie
        set_cookie

        phs = @final_photographer.map {|r| r.attributes.symbolize_keys}

        phs.each do |ph|
          ph[:rate] = (ph[:arate] + ph[:qrate]) / 4
          photographer = Photographer.find(ph[:id].to_i)
          if photographer.photographer_attachments.any?
            attachments = photographer.photographer_attachments
          end
          ph[:attachments] = attachments
          ph[:avatar] = photographer.avatar
          ph.except!(:encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :last_sign_in_at, :email, :static_number, :ideal_hours, :join_step_id, :slug, :location_id, :online_portfolio, :instagram, :linkedin, :approved, :rejected, :bank_account_id, :qrate, :arate, :parent_photographer_id, :business_id, :twitter, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :birthday, :checked)
        end

        #Returns back list of available times
        render json: {data: phs.sort_by {|ph| -ph[:rate]}, success: true}, status: :accepted
      end


      def photos
        unless params[:photographer_id]
          render json: {errors: ["لطفا پارامتر رشته انتخابی را درست وارد نمایید"]}.to_json, status: :bad_request
          return
        end
        unless params[:shoot_type_id]
          render json: {errors: ["لطفا پارامتر رشته انتخابی را درست وارد نمایید"]}.to_json, status: :bad_request
          return
        end
        photos = []
        Expertise.approved.find_by(:shoot_type => params[:shoot_type_id], :photographer => params[:photographer_id]).photos.each do |p|
          photos << p
        end
        # Expertise.approved.where(:photographer => params[:photographer_id]).each do |ex|
        #   if ex.shoot_type.id != params[:shoot_type_id]
        #     ex.photos.each do |p|
        #       photos << p
        #     end
        #   end
        # end
        if photos.any?
          render json: {photos: [photos]}.to_json, status: :accepted
        else
          render json: {errors: ["متاسفانه عکسی یافت نشد"]}, status: :bad_request
        end
      end

      def portfolio
        result = Photographers::PortfolioCreate.call(data: photographers_params)
        if result.success?
          render json: Rw::SuccessResponse.call(additional_json: nil).result
        else
          render json: {errors: result.errors}, status: :bad_request
        end
      end


      private

      def photographers_params
        params.require(:photographer).permit(:date, :first_name, :last_name, :mobile_number,
          :static_number, :email, :password, :ideal_hours,
          :parent_id, :uid, :avatar, :linkedin, :twitter,
          :instagram, :online_portfolio, :id, :change_step)

        end

        def time_in_range?(start_time, end_time, ph_free_start_time, ph_free_end_time)
          start_time.between?(ph_free_start_time, ph_free_end_time) && end_time.between?(ph_free_start_time, ph_free_end_time)
        end

      end
