class ReserveController < ApplicationController
  include ApplicationHelper
  include ReserveHelper

  before_action :authenticate_user!, except: [:initiate, :submit_extra_hour, :check_coupon]

  before_action :find_friendly_project , only: :check_coupon

  before_action :find_project, only: [:submit_photographer, :submit_detail, :submit_location_date, :pick_photograph, :submit_location, :submit_extra_hour]

  def initiate
    if params[:b].present? and Business.where(:name => params[:b]).any?
      business = Business.find_by_name(params[:b])
      business.refers = business.refers + 1
      business.save
      if user_signed_in?
        redirect_to business_projects_path(business.name, request.params)
      else
        redirect_to users_register_path(request.params)
      end
      # if other params present, send to package path, and dont ask the questions again
      # how to connect each project to business ?
      # redirect_to business_projects_path(business.name,request.params)
    elsif params[:ph].present? and Photographer.where(:uid => params[:ph]).any?
      photographer = Photographer.find_by_uid(params[:ph])
      if user_signed_in?
        redirect_to direct_reserve_path(:photographer_id => photographer.uid)
      else
        redirect_to users_register_path(request.params)
      end
    else
      # @project = Project.new
      # @project.save
      redirect_to home_path
    end
  end

  # POST ############
  def package
    @project = Project.new
    ##@project.save
    ## user_name = params[:name]
    ## user_family = params[:family]
    ## user_mobile_number = params[:mobile_number]
    ## user_email = params[:email]
    #coupon_code = params[:coupon_code]
    ## add business if present
    if params[:business_name].present?
      @project.business = Business.find_by_name(params[:business_name])
    end

    # add photographer if present
    if params[:photographer_id].present?
      photographer = Photographer.find_by_uid(params[:photographer_id])
      @project.photographer = photographer
    end
    #
    # @user = User.find_by(:mobile_number => params[:mobile_number]) #User.where(:email => user_email,:mobile_number=> user_mobile_number)
    # if @user
    @user = current_user

    @user.company_name = params[:company] if params[:company].present?
    @user.email = params[:email] if params[:email].present?
    @user.first_name = params[:name] if params[:name].present?
    @user.last_name = params[:family] if params[:family].present?
    @user.save
    # Legacy ( before user devise )
    # else
    # @user = User.new(company_name:params[:company],email:params[:email],mobile_number:params[:mobile_number],first_name:params[:name],last_name:params[:family])
    # @user.save
    # end
    # byebug

    @project.user = @user
    # add shoot type
    @project.shoot_type = ShootType.find(params["speciality-id"])
    # add package
    @project.package = Package.find(params["package-id"])
    # add receipt

    # add delivery method
    if params["memory-plus"] == "1"
      @project.delivery_at_location = true
    end

    @project.save
    @project.set_reserve_step("package")

    receipt = Receipt.new
    if @project.receipt.present?
      receipt = @project.receipt
      receipt.total = @project.package.price
      receipt.s ubtotal = receipt.total
      receipt.user = @project.user
    elsif params[:price].present?
      receipt = Receipt.new(total: params[:price], subtotal: params[:price], user: @user)
    else
      puts "creating new receipt for project"
      receipt = Receipt.new(total: @project.package.price, subtotal: @project.package.price, user: @user)
    end

    # receipt.ph_payment = receipt.calculate_ph_payment(receipt.total.to_i, @project.package.photographer_commission)
    ActiveRecord::Base.transaction do
      receipt.save
      @project.receipt = receipt
      @project.save
    end

    redirect_to where_and_when_project_path(@project)
  end


  def submit_location_date
    project_date = params[:date]
    project_hour = params[:time]
    project_latt = params[:latitude]
    project_long = params[:longitude]
    project_address = params[:address]
    project_address_detail = params["address-detail"]
    # ##address## #
    address = Address.new
    address.input = project_address
    address.detail = project_address_detail
    address.longtitude = project_long
    address.lattitude = project_latt
    address.save
    @project.address = address
    # ## start date and start time ## #
    @project.start_date = project_date.to_date
    # sh = StartHour.find_by_title(project_hour)
    # @project.start_hour = project_hour
    ph = project_hour.tr(':۰۱۲۳۴۵۶۷۸۹', ':0123456789')
    # hour = ph.split(":").first
    # minute = ph.split(":").second
    @project.start_time = "#{@project.start_date} #{ph}".in_time_zone('Tehran').in_time_zone('UTC')
    # @project.start_time = DateTime.new(@project.start_date.year,@project.start_date.month,@project.start_date.day,hour.to_i,minute.to_i,0,'+0430')
    day = @project.start_date.strftime("%A")
    pday = convert_persian_day(day)
    @project.week_day = WeekDay.find_by_name(pday)
    @project.start_hour = StartHour.find_by(:title => params[:time], :week_day => @project.week_day_id)
    # #### #
    @project.set_reserve_step("date")
    @project.save
    redirect_to photographer_project_path(@project)
  end


  def submit_photographer
    photographer = params[:photographer]
    ph = Photographer.find(photographer)
    @project.photographer = ph
    @project.set_reserve_step("photographer")
    @project.save
    redirect_to details_project_path(@project)
  end

  def submit_detail
    project_shoot_style = params["shoot-style"]
    project_feedback_channel = params["feedback_channel"]
    @project.shoot_detail = project_shoot_style
    fc = FeedbackChannel.find(project_feedback_channel)
    fc.times = 0 if fc.times.nil?
    fc.times = fc.times + 1
    fc.save
    @project.feedback_channel = fc
    @project.set_reserve_step("details")
    @project.save
    redirect_to receipt_project_path(@project)
  end

  def submit_extra_hour
    hours_requested = 0
    unless params[:"half-hour"].present?

      alert = "لطفا پکیج تمدید ساعت را انتخاب کنید."
      redirect_to extra_hour_project_path(@project.slug), notice: alert
    end
    hours_requested = params[:"half-hour"].to_f

    @project.extra_hour_requested = hours_requested
    @project.save

    @project.user.create_activity :submitted_extra_hour, owner: @project.user, recipient: @project


    if @project.delivery_at_location
      # if M+ , should go to receipt
      redirect_to extra_receipt_project_path(@project.slug), notice: "درخواست #{hours_requested} ساعت تمدید ثبت شد."
    else
      # if normal send sms to ph that extension payment received and u can continue photography
      #       sms_message=<<-text
      # درخواست تمدید #{hours_added} ساعت بیشتر از #{@project.user.display_name} تائید شد.
      # با آرزوی موفقیت،
      # تیم کادرو
      # text
      # SmsWorker.perform_async(sms_message,@project.photographer.mobile_number)
      redirect_to extra_receipt_project_path(@project.slug), notice: "درخواست #{hours_requested} ساعت تمدید عکاسی."
    end
  end


  def day_start_hours
    puts params[:date]
    date = params[:date].to_date
    day = date.strftime("%A")
    pday = convert_persian_day(day)
    puts pday

    @project = Project.friendly.find(params[:project_id])
    dure = convert_package_duration_number(@project.package.duration)
    result2 = available_hours(dure, params[:date], @project.shoot_type.id)
    respond_to do |format|
      format.json do
        render json: result2.to_json
      end
    end
  end

  #chek and submit coupon
  def check_coupon
    unless coupons_params[:code]
      render json: {errors: ["کد را صحیح وارد کنید"]}.to_json, status: :bad_request
      return
    end
    result = []
    code = coupons_params[:code]
    project = @project
    receipt = project.receipt
    if Coupon.all.where(code: code).any?
      coupon = Coupon.where(code: code).first
      if coupon.valid_from.present? && coupon.valid_until.present?
        in_range = Time.now.between?(coupon.valid_from, coupon.valid_until)
      elsif !coupon.valid_from && !coupon.valid_until
        in_range = true
      else
        in_range = false
      end
      if in_range
        if coupon.redemption_limit > coupon.used_times
          if coupon.is_active and project.coupon.nil?
            if !coupon.coupon_shoot_types.any?
              message = ""
              if coupon.is_percent
                message = "تبریک، #{coupon.value} درصد تخفیف به فاکتور شما اعمال شد."
                receipt.subtotal = project.package.price.to_i - ((coupon.value.to_i * project.package.price.to_i) / 100)
              else
                message = "تبریک، #{coupon.value} تومان تخفیف به فاکتور شما اعمال شد."
                receipt.subtotal = project.package.price.to_i - coupon.value.to_i
              end
              receipt.subtotal = receipt.subtotal.to_i + receipt.transportion_cost.to_i
              coupon_redemptions = CouponRedemption.new
              coupon_redemptions.coupon = coupon
              coupon_redemptions.user = project.user
              coupon_redemptions.receipt = receipt
              if coupon_redemptions.save
                if coupon.applied_times.nil?
                  coupon.applied_times = 0
                end
                coupon.applied_times = coupon.applied_times + 1
                coupon.save
                receipt.coupon = coupon
                receipt.save
                project.coupon = coupon
                project.save
                @project.create_activity :submitted_coupon, owner: @project.user, recipient: coupon
                result = {response: 'ok', message: message, discounted_price: receipt.subtotal}
              else
                result = {response: 'error', message: "#{coupon_redemptions.errors[:base].first}"}
              end
            else
              condition = false
              shoot_type = []
              coupon.coupon_shoot_types.each do |coupon_shoot_types|
                shoot_type << coupon_shoot_types.shoot_type.title
                if coupon_shoot_types.shoot_type == project.shoot_type
                  condition = true
                end
              end
              if condition
                message = ""
                if coupon.is_percent
                  message = "تبریک، #{coupon.value} درصد تخفیف به فاکتور شما اعمال شد."
                  receipt.subtotal = receipt.total.to_i - ((coupon.value.to_i * receipt.total.to_i) / 100)
                else
                  message = "تبریک، #{coupon.value} تومان تخفیف به فاکتور شما اعمال شد."
                  receipt.subtotal = receipt.total.to_i - coupon.value.to_i
                end
                coupon_redemptions = CouponRedemption.new
                coupon_redemptions.coupon = coupon
                coupon_redemptions.user = project.user
                coupon_redemptions.receipt = receipt
                if coupon_redemptions.save
                  if coupon.applied_times.nil?
                    coupon.applied_times = 0
                  end
                  coupon.applied_times = coupon.applied_times + 1
                  coupon.save
                  receipt.coupon = coupon
                  receipt.save
                  project.coupon = coupon
                  project.save
                  @project.user.create_activity :submitted_coupon, owner: @project.user, recipient: coupon
                  result = {response: 'ok', message: message, discounted_price: receipt.subtotal}
                else
                  result = {response: 'error', message: "#{coupon_redemptions.errors[:base].first}"}
                end
              else
                result = {response: 'error', message: "این کد تخفیف برای رشته  #{shoot_type} موجود می باشد."}
              end
            end
          elsif not coupon.is_active
            result = {response: 'error', message: "این کد تخفیف هم اکنون فعال نیست."}
          else
            result = {response: 'error', message: "شما یک بار کد تخفیف اعمال کرده اید."}
          end
        else
          result = {response: 'error', message: "این کد تخفیف قبلا استفاده شده."}
        end
      else
        result = {response: 'error', message: "متاسفانه شما در این زمان مجاز به استفاده از این کد تخفیف نیستید."}
      end
    else
      if user_signed_in?
        is_signed_in = true
      else
        is_signed_in = false
      end
      free_credit_value = Setting.find_by(var: 'free_credit').value.to_i

      refer = Refers::CheckRefer.call(code: code, user_id: current_user.present? ? current_user.id : 0, is_signed_in: is_signed_in, free_credit_value: free_credit_value.to_s.tr('0123456789', '۰۱۲۳۴۵۶۷۸۹'))
      if refer.free_credit.present?
        free_credit = free_credit_value
      else
        free_credit = 0
      end
      result = {response: refer.response, message: refer.message, discounted_price: receipt.subtotal.to_i - free_credit.to_i, free_credit: refer.free_credit.present? ? true : false}
    end
    # debugger
    if result[:response] == 'error'
      coupon = Coupon.find_by(code: coupons_params[:code])
      if coupon.nil?
        coupon =
        if coupons_params[:code][0..1] == '11' && coupons_params[:code].length == 8
          Coupon.create({title: 'کمپین نوروز ۹۸ ایرانسل',
            value: 10,
            is_percent: true,
            code: coupons_params[:code],
            is_active: true,
            used_times: 1,
            applied_times: 1,
            valid_from: '2019-03-06',
            valid_until: '2019-04-19',
            redemption_limit: 1,
            number_of_repetitions: 1,
            auto_generate: true})
          elsif coupons_params[:code][0..1] == '22' && coupons_params[:code].length == 8
            Coupon.create({title: 'کمپین نوروز ۹۸ ایرانسل',
              value: 20,
              is_percent: true,
              code: coupons_params[:code],
              is_active: true,
              used_times: 1,
              applied_times: 1,
              valid_from: '2019-03-06',
              valid_until: '2019-04-19',
              redemption_limit: 1,
              number_of_repetitions: 1,
              auto_generate: true})
            elsif coupons_params[:code][0..1] == '33' && coupons_params[:code].length == 8
              Coupon.create({title: 'کمپین نوروز ۹۸ ایرانسل',
                value: 30,
                is_percent: true,
                code: coupons_params[:code],
                is_active: true,
                used_times: 1,
                applied_times: 1,
                valid_from: '2019-03-06',
                valid_until: '2019-04-19',
                redemption_limit: 1,
                number_of_repetitions: 1,
                auto_generate: true})
              end
              if coupon
                message = "تبریک، #{coupon.value} درصد تخفیف به فاکتور شما اعمال شد."
                receipt.subtotal = receipt.total.to_i - ((coupon.value.to_i * receipt.total.to_i) / 100)
                receipt.coupon = coupon
                receipt.save
                project.coupon = coupon
                project.save
                result = {response: 'ok', message: message, discounted_price: receipt.subtotal}
              end
            end
          end

          respond_to do |format|
            format.json do
              render json: result.to_json
            end
          end
        end


        def pay
        end


        def coupons_params
          params.require(:coupon).permit(:code)
        end

        private
        def find_friendly_project
          @project = Project.friendly.find(params[:project_slug])
        end

        def find_project
          @project = Project.find(params[:project_id])
        end

      end
