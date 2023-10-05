class PhotographersController < ApplicationController
  layout :resolve_layout
  include PhotographersHelper
  include ApplicationHelper

  before_action :find_photographer, except: [:apply, :welcome, :portfolio_page, :check_uid, :join, :project_search, :settlement, :to_shares]
  before_action :authenticate_photographer!, except: [:update_times, :times, :apply, :welcome, :show, :portfolio_page, :check_uid, :join, :reject, :set_first_call]
  # skip_before_action :verify_authenticity_token , only: :receive_photo

  # before_action only: [:join, :experience, :equipments] do
  #   @photographer = current_photographer
  #   @photographer.create_activity action_name, owner: current_photographer
  # end

  def submit_studio_locations
    @shoot_location = ShootLocation.find_by(photographer_id: @photographer.id, is_studio: true)
    if params[:shoot_location][:approved] == "false"
      params[:shoot_location][:approved] = false
    end
    if params[:shoot_location][:title].present? && params[:shoot_location][:detail].present? && params[:shoot_location][:lattitude].present?
      if @shoot_location.present?
        @shoot_location.title = params[:shoot_location][:title]
        @shoot_location.is_studio = true
        @shoot_location.approved = params[:shoot_location][:approved]
        @shoot_location.photographer = @photographer
        address = Addresses::UpdateAddress.call(id: params[:shoot_location][:address_id], lattitude: params[:shoot_location][:lattitude], longtitude: params[:shoot_location][:longtitude], input: params[:shoot_location][:input], detail: params[:shoot_location][:detail]).address
        @shoot_location.address = address
      else
        @shoot_location = ShootLocation.new(title: params[:shoot_location][:title], is_studio: true, photographer_id: @photographer.id, approved: params[:shoot_location][:approved])
        address = Addresses::CreateAddress.call(lattitude: params[:shoot_location][:lattitude], longtitude: params[:shoot_location][:longtitude], input: params[:shoot_location][:input], detail: params[:shoot_location][:detail]).address
        @shoot_location.address = address
        @photographer.has_studio = true
        @photographer.save
      end
      if @shoot_location.save
        if params["shoot_types"].present?
          @shoot_location.shoot_type_locations.update_all(:active => false)
          params["shoot_types"].each do |sh|
            shoot_type = ShootType.find_by(id: sh.to_i)
            shoot_type_location = ShootTypeLocation.find_by(shoot_location_id: @shoot_location.id, shoot_type_id: shoot_type.id)
            if shoot_type_location.present?
              shoot_type_location.active = true
            else
              shoot_type_location = ShootTypeLocation.new(shoot_location_id: @shoot_location.id, shoot_type_id: shoot_type.id)
            end
            shoot_type_location.save
          end
          @shoot_location.photographer.expertises.each do |e|
            if e.approved
              shoot_type_location = ShootTypeLocation.find_by(shoot_location_id: @shoot_location.id, shoot_type_id: e.shoot_type.id)
              unless shoot_type_location.present?
                shoot_type_location = ShootTypeLocation.new(shoot_location_id: @shoot_location.id, shoot_type_id: e.shoot_type.id, active: false)
                shoot_type_location.save
              end
            end
          end
        end
        redirect_to studio_locations_photographer_path(@photographer), notice: "اطلاعات با موفقیت ذخیره شد."
      else
        redirect_to studio_locations_photographer_path(@photographer), alert: @shoot_location.errors.messages
      end
    else
      redirect_to studio_locations_photographer_path(@photographer), alert: "اطلاعات را به صورت کامل وارد نمایید."
    end
  end

  def studio_locations
    @shoot_location = ShootLocation.find_by(photographer_id: @photographer.id, is_studio: true)
    if @shoot_location.present?
      @shoot_location_attachments = @shoot_location.shoot_location_attachments
    end
  end

  def to_shares
    @photographer = current_photographer
    @frames = Frame.joins(:gallery => :project).where(:projects => { is_uploaded: true, photographer_id: @photographer.id }).where("frames.share_control_id IS NOT NULL")
  end

  def join
    @kadro = ""
    join_step = 0
    photographer = nil
    location = nil
    photographer_lenzs = nil
    photographer_cameras = nil
    photographer_kits = nil
    photographer_equipment = nil
    kits = nil
    cameras = nil
    lenzs = nil
    shoot_types = nil
    photographer_expertises = nil
    photographer_experience = nil

    if current_photographer
      join_step = current_photographer.join_step.code
      if current_photographer.join_step == JoinStep.find_by(:name => "تاییدیه") or current_photographer.join_step == JoinStep.find_by(:name => "تایید نهایی") or current_photographer.join_step == JoinStep.find_by(:name => "تجربه کاری") and !params[:step].present?
        redirect_to studio_photographer_path(current_photographer)
      else
        info = Photographers::PhotographerStepInfo.call(photographer_id: current_photographer.id)

        photographer = ActiveModelSerializers::SerializableResource.new(
          info.photographer, each_serializer: PhotographerSerializer,
        ).as_json

        location = info.location ?
          ActiveModelSerializers::SerializableResource.new(
          info.location, each_serializer: LocationSerializer,
        ).as_json : nil

        photographer_lenzs = info.lenzs ?
          ActiveModelSerializers::SerializableResource.new(
          info.lenzs, each_serializer: LenzSerializer,
        ).as_json : nil

        photographer_cameras = info.cameras ?
          ActiveModelSerializers::SerializableResource.new(
          info.cameras, each_serializer: CameraSerializer,
        ).as_json : nil

        photographer_kits = info.kits ?
          ActiveModelSerializers::SerializableResource.new(
          info.kits, each_serializer: KitSerializer,
        ).as_json : nil

        photographer_equipment = info.equipment ?
          ActiveModelSerializers::SerializableResource.new(
          info.equipment, each_serializer: EquipmentSerializer,
        ).as_json : nil
        photographer_expertises = info.photographer_expertises ?
          ActiveModelSerializers::SerializableResource.new(
          info.photographer_expertises, each_serializer: ExpertiseSerializer,
        ).as_json : nil
        photographer_experience = info.experience ?
          ActiveModelSerializers::SerializableResource.new(
          info.experience, each_serializer: ExperienceSerializer,
        ).as_json : nil

        joins = Photographers::JoinLookups.call
        kits = ActiveModelSerializers::SerializableResource.new(
          joins.kits, each_serializer: KitSerializer,
        ).as_json
        cameras = ActiveModelSerializers::SerializableResource.new(
          joins.cameras, each_serializer: CameraSerializer,
        ).as_json
        lenzs = ActiveModelSerializers::SerializableResource.new(
          joins.lenzs, each_serializer: LenzSerializer,
        ).as_json
        shoot_types = ActiveModelSerializers::SerializableResource.new(
          joins.shoot_types, each_serializer: ShootTypeSerializer,
        ).as_json

        # Rails.logger.info(photographer.to_yaml)
        # Rails.logger.info(location.to_yaml)

        # debugger
        if Rails.env.production?
          @kadro = "https://app.kadro.me"
        elsif Rails.env.development?
          @kadro = "http://app.localhost:3000"
        elsif Rails.env.staging?
          @kadro = "http://185.53.143.141:3005"
        end
        render locals: { join_step: join_step, photographer: photographer, location: location,
                         photographer_lenzs: photographer_lenzs, photographer_cameras: photographer_cameras,
                         photographer_kits: photographer_kits, photographer_equipment: photographer_equipment,
                         lenzs: lenzs, cameras: cameras, kits: kits, shoot_types: shoot_types,
                         photographer_expertises: photographer_expertises,
                         photographer_experience: photographer_experience }
      end
    else
      render locals: { join_step: join_step, photographer: photographer, location: location,
                       photographer_lenzs: photographer_lenzs, photographer_cameras: photographer_cameras,
                       photographer_kits: photographer_kits, photographer_equipment: photographer_equipment,
                       lenzs: lenzs, cameras: cameras, kits: kits, shoot_types: shoot_types,
                       photographer_expertises: photographer_expertises,
                       photographer_experience: photographer_experience }
    end
  end

  def show
    redirect_to @photographer.pro_url
  end

  def welcome
  end

  def apply
    if photographer_signed_in?
      redirect_to studio_photographer_path(current_photographer)
    end
    # byebug
  end

  def update_info
    if params[:photographer].present?
      @photographer = current_photographer
      @location = Location.find_by_id(@photographer.location_id)
      @photographer.first_name = photographers_params[:first_name]
      @photographer.last_name = photographers_params[:last_name]
      @photographer.mobile_number = photographers_params[:mobile_number]
      @photographer.uid = photographers_params[:uid]
      @photographer.birthday = photographers_params[:birthday]
      @location.working_input = photographers_params[:working_input]
      # @location.living_lat = photographers_params[:living_lat]
      # @location.living_long = photographers_params[:living_long]
      # @location.working_lat = photographers_params[:working_lat]
      # @location.working_long = photographers_params[:working_long]
      # @location.living_input = photographers_params[:living_input]
      # @location.working_input = photographers_params[:working_input]
      # @location.living_address = photographers_params[:living_address]
      @photographer.save
      @location.save
      @photographer.create_activity :ph_update_info, owner: @photographer
      redirect_to edit_info_photographer_path(@photographer), alert: "Profile successfuly updated!"
    end
  end

  def edit_info
    @photographer = current_photographer
    Photographers::AuthorizePhotographer.call(photographer: current_photographer, id: params[:id])
  rescue Rw::PermissionError
    redirect_to controller: "photographers", action: "studio",
                id: current_photographer.mobile_number,
                error: "permission_error"
  end

  def edit_photographer_shoot_type
    @photographer = current_photographer
    @shoot_type = ShootType.find_by(title: params[:shoot_type_title])
    @expertise = Expertise.find_by(shoot_type_id: @shoot_type, photographer_id: @photographer.id)
    if !@expertise.present?
      @expertise = Expertise.new(shoot_type_id: @shoot_type.id, photographer_id: @photographer.id, approved: false)
    end
    Photographers::AuthorizePhotographer.call(photographer: current_photographer, id: params[:id])
  rescue Rw::PermissionError
    redirect_to controller: "photographers", action: "studio",
                id: current_photographer.mobile_number,
                error: "permission_error"
  end

  def times
    if params[:id].present?
      @photographer = Photographer.friendly.find(params[:id])
    elsif photographer_signed_in?
      @photographer = current_photographer
    else
      redirect_to photographers_join_path, alert: "پیش از ادامه وارد شوید."
    end
  end

  def update_times
    # @photographer = current_photographer
    if params[:free_time].present?
      result = []
      if free_times_params["start_8"].present? and free_times_params["end_8"].present?
        result << [day: 8, start: free_times_params["start_8"], end: free_times_params["end_8"]]
      else
        for i in 1..7
          result << [day: i, start: free_times_params["start_#{i}"], end: free_times_params["end_#{i}"]]
        end
      end
      day_number_log = nil
      @photographer.free_times.destroy_all
      result.each do |item|
        if item.first[:start].present? && item.first[:end].present?
          free_time = @photographer.free_times.build(day: item.first[:day], start: item.first[:start], end: item.first[:end])
          unless free_time.save
            if day_number_log.nil?
              day_number_log = convert_persian_number_day(item.first[:day], true)
            end
          end
        elsif item.first[:start].present? || item.first[:end].present?
          if day_number_log.nil?
            day_number_log = convert_persian_number_day(item.first[:day], true)
          end
        end
      end
      if day_number_log.nil?
        redirect_to times_photographer_path(@photographer), notice: "اطلاعات با موفقیت ذخیره شد."
      else
        return redirect_to times_photographer_path(@photographer), alert: "روز #{day_number_log} باید در بازه مجاز ۷:۰۰ صبح الی ۱۲:۰۰ شب باشد."
      end
    else
      redirect_to times_photographer_path(@photographer), alert: "زمان های ورودی را به صورت صحیح وارد نمایید."
    end
  end

  def update_bank_account
    if params[:photographer].present?
      @photographer = current_photographer
      @bank_account = BankAccount.find_by(:photographer_id => @photographer.id)
      if !@bank_account.present?
        @bank_account = BankAccount.new
      end
      @bank_account.card_number = photographers_params[:card_number]
      @bank_account.shaba = photographers_params[:shaba]
      @bank_account.card_name = photographers_params[:card_name]
      @bank_account.card_last_name = photographers_params[:card_last_name]
      @bank_account.bank_name = photographers_params[:bank_name]
      @bank_account.photographer_id = @photographer.id
      if @bank_account.save
        @photographer.bank_account = @bank_account
        @photographer.save
        @photographer.create_activity :ph_update_bank_account, owner: @photographer, recipient: @bank_account
        redirect_to bank_account_photographer_path(@photographer), alert: "اطلاعات با موفقیت ذخیره شد."
      else
        redirect_to bank_account_photographer_path(@photographer), alert: @bank_account.errors.messages[:shaba].join(",")
      end
    end
  end

  def bank_account
    @photographer = current_photographer
  end

  def equipments
    Photographers::AuthorizePhotographer.call(photographer: current_photographer, id: params[:id])
  rescue Rw::PermissionError
    redirect_to controller: "photographers", action: "studio",
                id: current_photographer.mobile_number,
                error: "permission_error"
  end

  def experience
    Photographers::AuthorizePhotographer.call(photographer: current_photographer, id: params[:id])
    if @photographer.experience.present?
      @experience = @photographer.experience
    else
      @experience = Experience.new
      @experience.photographer = @photographer
      @experience.save
    end
  rescue Rw::PermissionError
    redirect_to controller: "photographers", action: "studio",
                id: current_photographer.mobile_number,
                error: "permission_error"
  end

  def portfolio
    Photographers::AuthorizePhotographer.call(photographer: current_photographer, id: params[:id])
  rescue Rw::PermissionError
    redirect_to controller: "photographers", action: "studio",
                id: current_photographer.mobile_number,
                error: "permission_error"
  end

  def done
    Photographers::AuthorizePhotographer.call(photographer: current_photographer, id: params[:id])
  rescue Rw::PermissionError
    redirect_to controller: "photographers", action: "studio",
                id: current_photographer.mobile_number,
                error: "permission_error"
  end

  def studio
    if params[:notice] == "success_save"
      flash.now[:notice] = "اطلاعات با موفقیت ذخیره شد."
    end
    @photographer = current_photographer
    projects_number = Photographers::Analyze::PhotographerProjectsCount.call(photographer_id: @photographer.id).projects_number
    total_income = Photographers::Analyze::PhotographerTotalIncome.call(photographer_id: @photographer.id).total_income
    customers_number = Photographers::Analyze::PhotographerCustomersCount.call(photographer_id: @photographer.id).customers_number
    duration_total = Photographers::Analyze::PhotographyDurationTotal.call(photographer_id: @photographer.id).total_time
    frames_number = Photographers::Analyze::PhotographerUploadedFramesCount.call(photographer_id: @photographer.id).frames_number
    download_number = Photographers::Analyze::PhotographerFramesDownloadsCount.call(photographer_id: @photographer.id).download_number
    suggestion_times = Photographers::Analyze::PhotographerSuggestionTimes.call(photographer_id: @photographer.id).suggestion_times
    result = Photographers::Analyze::PhotographerRate.call(photographer_id: @photographer.id)
    qrate = result.qrate
    arate = result.arate
    bought_frames = Photographers::Analyze::PhotographerBoughtFrames.call(photographer_id: @photographer.id).bought_frames

    payments = PhotographerPayments::PhPayments.call(photographer_id: @photographer.id).payments

    render locals: { projects_number: projects_number, total_income: total_income, customers_number: customers_number,
                     duration_total: duration_total, frames_number: frames_number, download_number: download_number, suggestion_times: suggestion_times, arate: arate, qrate: qrate, bought_frames: bought_frames, payments: payments }

    @permission_error = params[:error]
    Photographers::AuthorizePhotographer.call(photographer: current_photographer, id: params[:id])
  rescue Rw::PermissionError
    redirect_to controller: "photographers", action: "studio",
                id: current_photographer.mobile_number,
                error: "permission_error"
  end

  def payments_detail
    @project = @photographer.projects.find(params[:project])
  end

  def shop_details
    @shop_orders = ShopOrderDetail.joins(invoice_item: :invoice)
      .joins("inner join cart_items ci on ci.id = invoice_items.cart_item_id")
      .joins("inner join items i on i.id = ci.item_id")
      .joins("inner join frames f on f.id = ci.frame_id")
      .where("invoices.id = ? and photographer_id = ?", params[:invoice_id], current_photographer.id)
      .select("shop_order_details.*,invoice_items.price, invoice_items.quantity, invoice_items.unit_price ,f.id frame_id, i.title").load
  end

  # submit part

  def submit_basic_info
    # happens in photographer registrations controller
  end

  def submit_equipment
    # if @photographer.approved
    #   Photographer.where(:id => @photographer.id).update(:approved => false)
    # end
    unless @photographer.has_passed("تجهیزات عکاسی")
      @photographer.join_step_id = JoinStep.find_by_name("تجهیزات عکاسی").id # to skip update if ph is confirmed
    end

    if @photographer.equipment.present?
      equipment = @photographer.equipment
    else
      equipment = Equipment.new(:photographer => @photographer)
    end

    equipment.equipment_kits.delete_all
    equipment.small_product_kit = false
    equipment.large_product_kit = false
    equipment.portable_light = false
    equipment.light_studio_kit = false
    equipment.portable_studio_kit = false
    if params[:dont_have].present? || !params[:kit].present?
      equipment.kits << Kit.find_by(title: "dont_have")
    else
      params[:kit].each do |kit_title|
        kit = Kit.find_by(title: kit_title)
        equipment.kits << kit
      end
    end
    if params[:kit].present?
      if params[:kit]["small-product-kit"].present? and params[:kit]["small-product-kit"] == "1"
        equipment.small_product_kit = true
      end
      if params[:kit]["large-product-kit"].present? and params[:kit]["large-product-kit"] == "1"
        equipment.large_product_kit = true
      end
      if params[:kit]["portable-light"].present? and params[:kit]["portable-light"] == "1"
        equipment.portable_light = true
      end
      if params[:kit]["light-studio-kit"].present? and params[:kit]["light-studio-kit"] == "1"
        equipment.light_studio_kit = true
      end
      if params[:kit]["portable-studio-kit"].present? and params[:kit]["portable-studio-kit"] == "1"
        equipment.portable_studio_kit = true
      end
    end
    equipment.save
    if params[:camera].present?
      equipment.equip_cameras.delete_all
      params[:camera].split(",").each do |c|
        cam = Camera.find(c)
        EquipCamera.create!(:camera => cam, :equipment => equipment)
      end
    end
    if params[:lenz].present?
      equipment.equip_lenzs.delete_all
      params[:lenz].split(",").each do |l|
        lenz = Lenz.find(l)
        EquipLenz.create!(:lenz => lenz, :equipment => equipment)
      end
    end
    @photographer.create_activity :ph_edit_equipments, owner: @photographer, recipient: equipment
    redirect_to portfolio_photographer_path(@photographer)
  end

  def submit_experience
    normal_ph_register_steps = false
    unless @photographer.has_passed("تجربه کاری")
      normal_ph_register_steps = true
      @photographer.join_step_id = JoinStep.find_by_name("تجربه کاری").id # to skip update if ph is confirmed
    end
    if @photographer.experience.present?
      experience = @photographer.experience
      experience.update(params[:experience].permit(:years_been_photographer, :projects_payed_count, :self_describe, :bio, :passion, :love_job, :favorite_shoots, :shoots, :city_shoots, :awards, :fun_fact))
    else
      experience = Experience.new(params[:experience].permit(:years_been_photographer, :projects_payed_count, :self_describe, :bio, :passion, :love_job, :favorite_shoots, :shoots, :city_shoots, :awards, :fun_fact))
      experience.photographer = @photographer
    end
    case params[:payed_work]
    when "no"
      experience.has_payed_work = false
      experience.projects_payed_count = 0
    when "yes"
      experience.has_payed_work = true
    end
    experience.save
    @photographer.save

    @photographer.create_activity :ph_edit_experience, owner: @photographer, recipient: experience

    if normal_ph_register_steps
      redirect_to done_photographer_path(@photographer)
    else
      redirect_to studio_photographer_path(@photographer)
    end
  end

  def submit_portfolio
    if ph = Photographer.find_by(:uid => params[:photographer][:uid]) and ph != @photographer
      redirect_to portfolio_photographer_path(@photographer), alert: "'#{params[:photographer][:uid]}' قبلا گرفته شده است، لطفا آی دی دیگری انتخاب کنید."
    else
      @photographer.uid = params[:photographer][:uid]
      @photographer.online_portfolio = params[:photographer][:online_portfolio]
      @photographer.instagram = params[:photographer][:instagram]
      @photographer.linkedin = params[:photographer][:linkedin]
      @photographer.twitter = params[:photographer][:twitter]
      @photographer.avatar = params[:photographer][:avatar] if not params[:photographer][:avatar].nil?

      unless @photographer.has_passed("نمونه کارها")
        @photographer.join_step_id = JoinStep.find_by_name("نمونه کارها").id # to skip update if ph is confirmed
      end
      @photographer.save
      @photographer.create_activity :ph_edit_portfolio, owner: @photographer
      Photographers::CheckPhotographerJoinStep.call(photographer_id: @photographer.id)
      redirect_to experience_photographer_path(@photographer)
    end
  end

  def submit_avatars
    if params[:file]
      photo = @photographer.photographer_attachments.create!(avatar: params[:file])
      file = photo.avatar.file
      dimentions = `identify -format "%wx%h" #{file.path}`.split(/x/)
      if dimentions[0] == "700" && dimentions[1] == "700"
        @photographer.create_activity :ph_upload_profile_photo, owner: @photographer, recipient: photo
      else
        FileUtils.remove_dir(File.dirname(photo.avatar.file.file))
        photo.delete
        head 406
      end
    end
  end

  def receive_photo
    @photo = Photo.new(params.require(:document).permit(:file))
    path = @photo.file.file.file
    exif_tool = Exiftool.new(path)
    exifs = exif_tool.raw
    exif = Exif.create(artist: exifs[:artist], copyright: exifs[:profile_copyright], camera_model: exifs[:model], serial_number: exifs[:serial_number], lens: exifs[:lens], date_created: exifs[:date_created], modify_date: exifs[:modify_date], exposure_time: exifs[:exposure_time], f_number: exifs[:f_number], exposure_program: exifs[:exposure_program], iso: exifs[:iso], focal_length: exifs[:focal_length], metering_mode: exifs[:metering_mode], software: exifs[:software], exposure: exifs[:exposure2012], contrast: exifs[:contrast2012], highlights: exifs[:highlights2012], shadows: exifs[:shadows2012], whites: exifs[:whites2012], blacks: exifs[:blacks2012], clarity: exifs[:clarity2012], saturation: exifs[:saturation], white_balance: exifs[:white_balance], color_temperature: exifs[:color_temperature], tint: exifs[:tint], sharpness: exifs[:sharpness], luminance_smoothing: exifs[:luminance_smoothing], color_noise_reduction: exifs[:color_noise_reduction], perspective_vertical: exifs[:perspective_vertical], perspective_horizontal: exifs[:perspective_horizontal], perspective_rotate: exifs[:perspective_rotate], perspective_scale: exifs[:perspective_scale], perspective_x: exifs[:perspective_x], perspective_y: exifs[:perspective_y], history_action: exifs[:history_action], history_parameters: exifs[:history_parameters], history_when: exifs[:history_when], history_software_agent: exifs[:history_software_agent], image_size: exifs[:image_size], vignette_correction: exifs[:vignette_correction_already_applied], distortion_correction: exifs[:distortion_correction_already_applied], lateral_chromatic_aberration_correction: exifs[:lateral_chromatic_aberration_correction_already_applied])
    @photo.exif = exif
    @photo.save

    shoot_type = params[:shoot_type_id]
    expertise = Expertise.where(:shoot_type => ShootType.find(shoot_type), :photographer => @photographer).first
    if expertise
      @photo.expertise = expertise
    else
      expertise = Expertise.new
      expertise.photographer = @photographer
      expertise.shoot_type = ShootType.find(shoot_type)
      expertise.save
      @photo.expertise = expertise
    end
    respond_to do |format|
      if @photo.save
        format.html {
          render :json => [@photo.to_jq_upload].to_json,
                 :content_type => "text/html",
                 :layout => false
        }
        format.json { render json: { files: [@photo.to_jq_upload] }, status: :created, location: @photo.file_url(:medium) }
      else
        format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def register_serial_number
    lenzs = @photographer.equipment.equip_lenzs
    cameras = @photographer.equipment.equip_cameras

    if params[:serial_numbers].present?
      flash[:alert] = "تغییری ثبت نشد"
      params[:serial_numbers].keys.each do |key|
        if params[:serial_numbers][key].present?
          if key.include? "c"
            id = key.split("c")[1]
            cameras.each do |eq_camera|
              if eq_camera.id == id.to_i
                eq_camera.serial_number = params[:serial_numbers][key]
                eq_camera.save
                flash[:alert] = "تغییرات با موفقیت ذخیره گردید"
                break
              end
            end
          elsif key.include? "l"
            id = key.split("l")[1]
            lenzs.each do |eq_lenz|
              if eq_lenz.id == id.to_i
                eq_lenz.serial_number = params[:serial_numbers][key]
                eq_lenz.save
                flash[:alert] = "تغییرات با موفقیت ذخیره گردید"
                break
              end
            end
          end
        end
      end
    elsif params[:submitted] == "true"
      flash[:alert] = "تغییری ثبت نشد"
    end
    render locals: { lenzs: lenzs, cameras: cameras }
  end

  def page_setting
    repetitious = @photographer.expertises.group(:order).having("count(*) > 1").size
    if @photographer.expertises.where(order: nil).present? or not repetitious.empty?
      @photographer.expertises.each_with_index do |item, index|
        item.order = index
        item.save
      end
    end
    @shoot_types = ShootTypes::ShootTypesLoad.call(photographer_id: @photographer.id).shoot_types
    @all_shoot_types = ShootTypes::ShootTypeSortForPhotographer.call(photographer: current_photographer).shoot_types
  end

  def set_order_of_expertise
    new_index = params[:newIndex]
    old_index = params[:oldIndex]
    differ = new_index.to_i - old_index.to_i
    expertises = []
    (new_index.to_i - old_index.to_i).abs.times do
      expertises << @photographer.expertises.where(order: old_index.to_i + differ).take
      if differ < 0
        differ = differ + 1
      else
        differ = differ - 1
      end
    end

    differ = new_index.to_i - old_index.to_i
    expertises.each do |expertise|
      if differ < 0
        expertise.order = expertise.order + 1
      else
        expertise.order = expertise.order - 1
      end
      expertise.save
    end

    expertise = @photographer.expertises.where(shoot_type_id: params[:shoot_type_id]).take
    expertise.order = params[:newIndex]
    expertise.save
  end

  def check_uid
  end

  def reject
    if params[:reject_photographer]
      @photographer.rejected = true
      @photographer.join_step_id = JoinStep.find_by(name: "لغو عضویت").id
      @photographer.save
    end
  end

  def set_first_call
    if params[:first_call]
      @photographer.first_call = true
      @photographer.first_call_at = Time.now
      @photographer.save
    end
  end

  def remove_expertise
    expertise = Expertise.find_by_id(params[:expertise_id])
    @shoot_type_id = expertise.shoot_type.id
    @expertise_id = expertise.id
    expertise.photos.delete_all
    if expertise.delete
      respond_to do |format|
        format.js
      end
    end
  end

  def remove_avatar
    if params[:avatar_id]
      attachment = @photographer.photographer_attachments.find(params[:avatar_id])
      attachment.delete
    end
  end

  def projects
    Photographers::AuthorizePhotographer.call(photographer: current_photographer, id: params[:id])
    @projects = @photographer.projects.payed
    # @projects = @photographer.projects.where(
    #   :reserve_step_id => ReserveStep.find_by(name: "wating_for_ph").id..ReserveStep.find_by(name: "checkout").id,
    # )
  rescue Rw::PermissionError
    redirect_to controller: "photographers", action: "studio",
                id: current_photographer.mobile_number,
                error: "permission_error"
  end

  def project_search
    params[:search][:from_date] = params[:search][:from_date].tr(":۰۱۲۳۴۵۶۷۸۹", ":0123456789")
    params[:search][:to_date] = params[:search][:to_date].tr(":۰۱۲۳۴۵۶۷۸۹", ":0123456789")
    params[:search][:from_date] = params[:search][:from_date].nil? || params[:search][:from_date] == "" ? nil :
      Kadro::JalaliToGregorian.call(date: params[:search][:from_date]).result
    params[:search][:to_date] = params[:search][:to_date].nil? || params[:search][:to_date] == "" ? nil :
      Kadro::JalaliToGregorian.call(date: params[:search][:to_date]).result

    @projects = Projects::Search.call(customer_name: params[:search][:customer_name],
                                      from_date: params[:search][:from_date],
                                      to_date: params[:search][:to_date],
                                      photographer_id: current_photographer.id).result
  end

  def checkout
    @photographer = current_photographer
    @payments = PhotographerPayments::PhPayments.call(photographer_id: @photographer.id).payments
    @total_ready_to_pay = Photographers::TotalReadyToPay.call(photographer_id: @photographer.id).total_ready_to_pay
    @total_free_payments = Photographers::TotalFreePayments.call(photographer_id: @photographer.id).total_free_payments
    @total_penalty = Photographers::TotalPenalty.call(photographer_id: @photographer.id).total_penalty
    @following_projects_pay = Photographers::FollowingProjectsPay.call(photographer_id: @photographer.id).payments
    @waiting_to_pay = Photographers::WaitingToPay.call(photographer_id: @photographer.id).waiting_to_pay
  end

  def settlement
    checkout_gateway = Setting.find_by(var: "checkout_gateway").value
    if checkout_gateway == "pay.ir"
      ActiveRecord::Base.transaction do
        result = PhotographerPayments::BatchPayment.call(ids: params[:pay_ids])

        if result.success
          Projects::SetProjectAsCheckout.call(ids: params[:pay_ids])
          current_photographer.create_activity :ph_settled_successfully, owner: current_photographer, params: { details: "مبلغ #{result.sum_price.to_s} از رکورد های با آیدی #{params[:pay_ids]}" }
        end

        data = { message: result.message, success: result.success, cashout_id: result.cashout_id }
        render json: data
      end
    elsif checkout_gateway == "jibit.ir"
      ActiveRecord::Base.transaction do
        result = Jibit::BatchPayment.call(ids: params[:pay_ids])

        if result.success
          Projects::SetProjectAsCheckout.call(ids: params[:pay_ids])
          current_photographer.create_activity :ph_settled_successfully, owner: current_photographer, params: { details: "مبلغ #{result.sum_price.to_s} از رکورد های با آیدی #{params[:pay_ids]}" }
        end

        data = { message: result.message, success: result.success, cashout_id: result.cashout_id }
        render json: data
      end
    end
  end

  def projects_of_candidate
    @first_load = 8
    @show_number = 2

    context = Projects::FindProjectsOfACandidate.call(photographer_id: current_photographer.id, from: 0, show_number: @first_load)
    @projects = context.projects
    @size = context.size
    @photographer_rivals = Photographers::PhotographerRivals.call(ids: @projects.map(&:id), photographer_id: current_photographer.id).photographers
  end

  def load_more_projects_you_candidated
    projects_to_show_number = params[:show_number].to_i
    showed_projects = params[:showed_projects]
    start_project_number = showed_projects.to_i + 1
    @projects = Projects::FindProjectsOfACandidate.call(photographer_id: current_photographer.id, from: start_project_number, show_number: projects_to_show_number).projects
    @photographer_rivals = Photographers::PhotographerRivals.call(ids: @projects.map(&:id), photographer_id: current_photographer.id).photographers
  end

  def confirm_my_email
    DeviseWorker.perform_async(@photographer.id)
    @photographer.confirmation_sent_at = Time.now
    @photographer.save
    redirect_to studio_photographer_url(@photographer), alert: "ایمیلی حاوی لینک تاییدیه برای آدرس ایمیل شما ارسال گردید."
  end


  def home
  end

  private

  def resolve_layout
    case action_name
    when "show"
      "kadro"
    when "join"
      "join"
    when "apply"
      "wordpress"
    else
      "wordpress"
    end
  end

  def find_photographer
    @photographer = Photographer.friendly.find(params[:id])
  end

  def photo_params
    # params.require(:photo).permit(:document)
  end

  def photographers_params
    params.require(:photographer).permit(:uid, :mobile_number, :first_name, :last_name, :static_number, :birthday, :living_lat, :living_long, :working_lat, :working_long, :living_input, :working_input, :living_address, :card_name, :card_last_name, :card_number, :shaba, :bank_name)
  end

  def free_times_params
    params.require(:free_time).permit(:start_1, :start_2, :start_3, :start_4, :start_5, :start_6, :start_7, :start_8, :end_1, :end_2, :end_3, :end_4, :end_5, :end_6, :end_7, :end_8)
  end
end
