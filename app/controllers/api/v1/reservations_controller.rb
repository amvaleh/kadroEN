class Api::V1::ReservationsController < ApiController
  before_action :find_photographer, except: [:submit_package, :submit_address, :check_coupon, :submit_shoot_type]
  before_action :find_project, except: [:create]
  respond_to :json
  include Swagger::Docs::Methods

  swagger_controller :photographers, "Photographers"

  swagger_api :create do |api|
    summary "Create Project"
    Api::V1::ReservationsController::project_create(api)
    response :accepted
    response :bad_request
  end

  swagger_api :submit_package do |api|
    summary "Submit package on Project"
    Api::V1::ReservationsController::project_submit_package(api)
    response :accepted
    response :bad_request
  end

  swagger_api :check_coupon do |api|
    summary "Check coupon and Submit"
    Api::V1::ReservationsController::project_check_coupon(api)
    response :ok
    response :error
  end

  swagger_api :submit_address do |api|
    summary "Submit address on project"
    Api::V1::ReservationsController::project_submit_address(api)
    response :accepted
    response :bad_request
  end

  swagger_api :submit_shoot_type do |api|
    summary "Submit Shoot Type and return Packages"
    Api::V1::ReservationsController::project_submit_shoot_type(api)
    response :accepted
    response :bad_request
  end

  swagger_api :submit_photographer do |api|
    summary "Submit Photographer and return FeedbackChannel"
    Api::V1::ReservationsController::project_submit_photographer(api)
    response :accepted
    response :bad_request
  end

  swagger_api :submit_detail do |api|
    summary "Submit Shoot Detail and FeedbackChannel"
    Api::V1::ReservationsController::project_submit_detail(api)
    response :accepted
    response :bad_request
  end

  swagger_api :submit_delivery_at_location do |api|
    summary "Submit Delivery at Location"
    Api::V1::ReservationsController::project_submit_delivery_at_location(api)
    response :accepted
    response :bad_request
  end

  def self.project_create(api)
    api.param :header, "Authorization", :string, :required, "Authorization"
    api.param :path, "reserve[photographer_id]", :string, :required, "photographer id"
    api.param :form, "reserve[offset_package]", :string, :required, "offset package"
    api.param :form, "reserve[shoot_type_id]", :string, :required, "shoot type id"
    api.param :form, "reserve[package_id]", :string, :required, "package id"
    api.param :form, "reserve[coupon_id]", :string, :required, "coupon id"
    api.param :form, "reserve[user_id]", :string, :required, "user id"
    api.param :form, "reserve[receipt_id]", :string, :required, "receipt id"
    api.param :form, "reserve[address_id]", :string, :required, "address id"
    api.param :form, "reserve[start_time]", :string, :required, "start time"
  end

  def self.project_submit_package(api)
    api.param :header, "Authorization", :string, :required, "Authorization"
    api.param :form, "reserve[package_id]", :string, :required, "package id"
    api.param :form, "project_slug", :string, :required, "Project Slug"
  end

  def self.project_check_coupon(api)
    api.param :header, "Authorization", :string, :required, "Authorization"
    api.param :form, "coupon[code]", :string, :required, "Coupon Code"
    api.param :form, "project_slug", :string, :required, "Project Slug"
  end

  def self.project_submit_address(api)
    api.param :header, "Authorization", :string, :required, "Authorization"
    api.param :form, "address[longtitude]", :string, :required, "longtitude"
    api.param :form, "address[lattitude]", :string, :required, "lattitude"
    api.param :form, "address[input]", :string, :required, "input"
    api.param :form, "address[detail]", :string, :required, "detail"
    api.param :form, "project_slug", :string, :required, "Project Slug"
  end

  def self.project_submit_shoot_type(api)
    api.param :header, "Authorization", :string, :required, "Authorization"
    api.param :form, "shoot_type[id]", :string, :required, "Shoot Type ID"
    api.param :form, "project_slug", :string, :required, "Project Slug"
  end

  def self.project_submit_photographer(api)
    api.param :header, "Authorization", :string, :required, "Authorization"
    api.param :form, "photographer[id]", :string, :required, "Photographer ID"
    api.param :form, "project_slug", :string, :required, "Project Slug"
  end

  def self.project_submit_detail(api)
    api.param :header, "Authorization", :string, :required, "Authorization"
    api.param :form, "detail[shoot_detail]", :string, :required, "Shoot Detail Text"
    api.param :form, "detail[feedback_channel_id]", :string, :required, "Feedback Channel ID"
    api.param :form, "project_slug", :string, :required, "Project Slug"
  end

  def self.project_submit_delivery_at_location(api)
    api.param :header, "Authorization", :string, :required, "Authorization"
    api.param :form, "reserve[delivery_at_location]", :boolean, :required, "Delivery at Location"
    api.param :form, "project_slug", :string, :required, "Project Slug"
  end

  def create
    #note date and time => miladi
    date_time_parse = DateTime.parse(reserve_params[:start_time]) # date + time
    # rescue
    #   render json:"تاریخ و زمان با قالب ناصحیح داده شده است!".to_json,status: :bad_request
    if @package = Package.find(reserve_params[:package_id])
      day_of_week = helpers.convert_persian_number_day(date_time_parse.to_pdate.strftime("%A"))
      if @photographer.has_free_time?(date_time_parse, @package.order.to_i, day_of_week)
        project = @photographer.projects.build(start_time: reserve_params[:start_time],
                                               shoot_type_id: reserve_params[:shoot_type_id],
                                               package_id: reserve_params[:package_id],
                                               coupon_id: reserve_params[:coupon_id],
                                               user_id: reserve_params[:user_id],
                                               receipt_id: reserve_params[:receipt_id],
                                               address_id: reserve_params[:address_id])
        if project.save
          render json: { messages: ["عملیات با موفقیت انجام شد"] }, status: :accepted
        else
          render json: { errors: ["متاسفانه پروژه با موفقیت ایجاد نشد"] }, status: :bad_request
        end
      else
        render json: { errors: ["متاسفانه براساس زمان داده شده زمان خالی برای این عکاس وجود ندارد"] }, status: :bad_request
      end
    else
      render json: { errors: ["پکیج انتخابی یافت نشد!"] }, status: :bad_request
    end
  end

  # submit package in project
  def submit_package
    unless reserve_params[:package_id]
      render json: { errors: ["مقدار صحیح را وارد نمایید"] }.to_json, status: :bad_request
      return
    end
    @package = Package.find_by(id: reserve_params[:package_id])
    if @package.present?
      @project.package = @package
      @project.save
      @project.create_activity :submitted_package, owner: @project.user, recipient: @package
      receipt = @project.receipt
      ph_payment = 0
      if receipt
        #receipt = @project.receipt
        receipt.total = @project.package.price
        receipt.subtotal = receipt.total
        receipt.ph_payment = receipt.calculate_ph_payment(receipt.total.to_i, @package.photographer_commission, 0)
        # ( receipt.total.to_i * 0.9 ).to_s
        receipt.user = @project.user
      else
        receipt = Receipt.new(total: @project.package.price, subtotal: @project.package.price, user: @user)
        ph_payment = receipt.calculate_ph_payment(@project.package.price.to_i, @package.photographer_commission, 0)
        receipt.ph_payment = ph_payment
      end

      # add coupon
      coupon = @project.coupon
      if coupon && coupon.is_active
        if coupon.is_percent
          receipt.subtotal = receipt.total.to_i - ((coupon.value.to_i * receipt.total.to_i) / 100)
        else
          receipt.subtotal = receipt.total.to_i - coupon.value.to_i
        end
        coupon.used_times = coupon.used_times + 1
        coupon.save
        receipt.coupon = coupon
        @project.coupon = coupon
      end
      ActiveRecord::Base.transaction do
        receipt.save
        @project.receipt = receipt
        @project.set_reserve_step("package")
        @project.save
      end
      if params[:photographer].present?
        photographer = Photographer.find_by_uid(params[:photographer])
        direct_city_name = photographer.location.city.name
        render json: { messages: ["پکیج انتخابی با موفقیت اضافه شد"], direct_city_name: direct_city_name, direct_photographer_name: photographer.display_name }, result: "True", status: :accepted
      else
        render json: { messages: ["پکیج انتخابی با موفقیت اضافه شد"] }, result: "True", status: :accepted
      end
    else
      render json: { messages: ["پکیج انتخابی یافت نشد"] }, result: "False", status: :bad_request
    end
  end

  #chek and submit coupon
  def check_coupon
    unless coupons_params[:code]
      render json: { errors: ["کد را صحیح وارد کنید"] }.to_json, status: :bad_request
      return
    end
    result = []
    code = coupons_params[:code]
    project = @project
    receipt = project.receipt
    if project.coupon.nil?
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
            if coupon.is_active
              if project.coupon.nil?
                if !coupon.coupon_shoot_types.any?
                  message = ""
                  if coupon.is_percent
                    message = "تبریک، #{coupon.value} درصد تخفیف به فاکتور شما اعمال شد."
                    receipt.subtotal = (project.package.price.to_i * (project.address.city.impression_discount_package.to_f / 100)) - ((coupon.value.to_f / 100) * (project.package.price.to_i * (project.address.city.impression_discount_package.to_f / 100)))
                  else
                    message = "تبریک، #{coupon.value} تومان تخفیف به فاکتور شما اعمال شد."
                    receipt.subtotal = (project.package.price.to_i * (project.address.city.impression_discount_package.to_f / 100)) - coupon.value.to_i
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
                    result = { response: "ok", message: message, discounted_price: receipt.subtotal }
                  else
                    result = { response: "error", message: "#{coupon_redemptions.errors[:base].first}" }
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
                      @project.create_activity :submitted_coupon, owner: @project.user, recipient: coupon
                      result = { response: "ok", message: message, discounted_price: receipt.subtotal }
                    else
                      result = { response: "error", message: "#{coupon_redemptions.errors[:base].first}" }
                    end
                  else
                    result = { response: "error", message: "این کد تخفیف برای رشته  #{shoot_type} موجود می باشد." }
                  end
                end
              else
                result = { response: "error", message: "شما یک بار کد تخفیف اعمال کرده اید." }
              end
            else
              result = { response: "error", message: "این کد تخفیف هم اکنون فعال نیست." }
            end
          else
            result = { response: "error", message: "این کد تخفیف قبلا استفاده شده." }
          end
        else
          result = { response: "error", message: "متاسفانه شما در این زمان مجاز به استفاده از این کد تخفیف نیستید." }
        end
      else
        if user_signed_in?
          is_signed_in = true
        else
          is_signed_in = false
        end
        free_credit_value = Setting.find_by(var: "free_credit").value.to_i

        refer = Refers::CheckRefer.call(code: code, user_id: current_user.present? ? current_user.id : 0, is_signed_in: is_signed_in, free_credit_value: free_credit_value.to_s.tr("0123456789", "۰۱۲۳۴۵۶۷۸۹"))
        if refer.free_credit.present?
          free_credit = free_credit_value
        else
          free_credit = 0
        end

        if refer.free_credit.present?
          coupon = Coupon.create(title: "ریفرال " + project.user.display_name, value: free_credit, is_percent: false, applied_times: 1)
          receipt.coupon = coupon
          receipt.subtotal = receipt.total.to_i - free_credit.to_i
          receipt.save
          project.coupon = coupon
          project.save
          coupon.code = code
          coupon.save
          @project.create_activity :submitted_coupon, owner: @project.user, recipient: coupon
        end

        result = { response: refer.response, message: refer.message, discounted_price: receipt.subtotal.to_i, free_credit: refer.free_credit.present? ? true : false }
      end
    else
      result = { response: "error", message: "شما یک بار کد تخفیف اعمال کرده اید." }
    end
    # debugger
    if result[:response] == "error"
      coupon = Coupon.find_by(code: coupons_params[:code])
      if coupon.nil?
        coupon = if coupons_params[:code][0..1] == "11" && coupons_params[:code].length == 8
            Coupon.create({ title: "کمپین نوروز ۹۸ ایرانسل",
                            value: 10,
                            is_percent: true,
                            code: coupons_params[:code],
                            is_active: true,
                            used_times: 1,
                            applied_times: 1,
                            valid_from: "2019-03-06",
                            valid_until: "2019-04-19",
                            redemption_limit: 1,
                            number_of_repetitions: 1,
                            auto_generate: true })
          elsif coupons_params[:code][0..1] == "22" && coupons_params[:code].length == 8
            Coupon.create({ title: "کمپین نوروز ۹۸ ایرانسل",
                            value: 20,
                            is_percent: true,
                            code: coupons_params[:code],
                            is_active: true,
                            used_times: 1,
                            applied_times: 1,
                            valid_from: "2019-03-06",
                            valid_until: "2019-04-19",
                            redemption_limit: 1,
                            number_of_repetitions: 1,
                            auto_generate: true })
          elsif coupons_params[:code][0..1] == "33" && coupons_params[:code].length == 8
            Coupon.create({ title: "کمپین نوروز ۹۸ ایرانسل",
                            value: 30,
                            is_percent: true,
                            code: coupons_params[:code],
                            is_active: true,
                            used_times: 1,
                            applied_times: 1,
                            valid_from: "2019-03-06",
                            valid_until: "2019-04-19",
                            redemption_limit: 1,
                            number_of_repetitions: 1,
                            auto_generate: true })
          end
        if coupon
          message = "تبریک، #{coupon.value} درصد تخفیف به فاکتور شما اعمال شد."
          receipt.subtotal = receipt.total.to_i - ((coupon.value.to_i * receipt.total.to_i) / 100)
          receipt.coupon = coupon
          receipt.save
          project.coupon = coupon
          project.save
          result = { response: "ok", message: message, discounted_price: receipt.subtotal }
        end
      end
    end

    respond_to do |format|
      format.json do
        render json: result.to_json
      end
    end
  end

  #chek and submit address
  def submit_address
    unless addresses_params[:detail]
      render json: { errors: ["مقدار صحیح را وارد نمایید"] }.to_json, status: :bad_request
      return
    end
    @address = Project.find_by(id: @project.id).address
    @project.set_reserve_step("location")
    @project.in_studio = false
    if @address.present?
      Address.where(id: @address.id).first.update_attributes(longtitude: addresses_params[:longtitude], lattitude: addresses_params[:lattitude], input: addresses_params[:input], detail: addresses_params[:detail])
      message = " آدرس با موفقیت ذخیره شد"
    else
      @address = Address.create(longtitude: addresses_params[:longtitude], lattitude: addresses_params[:lattitude], input: addresses_params[:input], detail: addresses_params[:detail])
      Project.where(id: @project.id).first.update_attributes(address_id: @address.id)
      message = "آدرس برای پروژه ساخته شد"
    end
    # check for direct book photographer available days
    if params[:photographer].present?
      photographer = Photographer.find_by(uid: params[:photographer])
      avatar_url = photographer.avatar.mini.url
      available_hours = FreeTimes::CalculateAvailableWeekHours.call(photographer_id: photographer.id).available_hours
      active_days = photographer.free_times
      days = []
      active_days.each do |ad|
        days << ad.day
      end
      @project.direct_book = true
      # check for in-studio if direct book
      if addresses_params[:in_studio] == "true"
        @shoot_location = ShootLocation.find_by(photographer_id: photographer.id, is_studio: true, approved: true)
        if @shoot_location.present?
          @address.detail = @shoot_location.address.detail
          @address.save
        else
          @address.detail = photographer.location.living_address
          @address.save
        end
        @project.in_studio = true
      end
      @project.save
      #
      render json: { messages: [message], days: [days], avatar_url: avatar_url, available_hours: available_hours, photographer_name: photographer.abbrv_name }, result: "True", status: :accepted
    else
      @project.save
      render json: { messages: [message] }, result: "True", status: :accepted
    end
    # @project.create_activity :submitted_address, owner: @project.user, recipient: @address
  end

  #chek and submit shoot_type
  def submit_shoot_type
    unless shoot_type_params[:id]
      render json: { errors: ["لطفا پارامتر رشته انتخابی را درست وارد نمایید"] }.to_json, status: :bad_request
      return
    end

    @packages = Package.active.where(shoot_type_id: shoot_type_params[:id])
    if @packages.any?
      Project.where(id: @project.id).update_all(shoot_type_id: shoot_type_params[:id])

      @project.create_activity :submitted_shoot_type, owner: @project.user, recipient: ShootType.where(id: shoot_type_params[:id])[0]
      render json: { packages: [@packages],
                     recommendation: ShootType.find(shoot_type_params[:id]).recommended_hours }.to_json, status: :accepted
    else
      render json: { errors: ["رشته خود را درست انتخاب کنید"] }, status: :bad_request
    end
  end

  def submit_photographer
    unless photographer_params[:id]
      render json: { errors: ["لطفا پارامتر رشته انتخابی را درست وارد نمایید"] }.to_json, status: :bad_request
      return
    end
    Project.where(id: @project.id).update_all(photographer_id: photographer_params[:id])
    @project.set_reserve_step("photographer")
    @project.save
    if photographer_params[:price].present?
      price = photographer_params[:price].to_i
      receipt = @project.receipt
      receipt.subtotal = receipt.subtotal + price
      receipt.total = receipt.total + price
      receipt.ph_payment = receipt.ph_payment + price
      receipt.save
    end
    @project.create_activity :submitted_photographer, owner: @project.user, recipient: Photographer.where(id: photographer_params[:id])[0]
    @feedback = FeedbackChannel.all
    render json: { feedback: [@feedback] }, result: "True", status: :accepted
  end

  def submit_detail
    unless detail_params[:shoot_detail]
      render json: { errors: ["لطفا پارامتر رشته انتخابی را درست وارد نمایید"] }.to_json, status: :bad_request
      return
    end
    Project.where(id: @project.id).update_all(shoot_detail: detail_params[:shoot_detail], feedback_channel_id: detail_params[:feedback_channel_id])
    @project.set_reserve_step("details")
    @project.save
    # @project.user.create_activity :submitted_detail, owner: @project.user, recipient: @project

    credit = user_signed_in? ? current_user.credit.value : -1
    render json: { messages: ["اطلاعات با موفقیت ذخیره شد."], subtotal: @project.receipt.subtotal, transportation_cost: @project.receipt.transportion_cost, credit: credit }, result: "True", status: :accepted
  end

  def submit_delivery_at_location
    unless reserve_params[:delivery_at_location]
      render json: { errors: ["شما درخواستی بابت مموری پلاس ندارید."] }.to_json, status: :bad_request
      return
    end
    if reserve_params[:delivery_at_location]
      if reserve_params[:delivery_at_location] == "true"
        @project.delivery_at_location = true
        @project.save
        @project.user.create_activity :submitted_delivery_true, owner: @project.user, recipient: @project
      elsif reserve_params[:delivery_at_location] == "false"
        @project.delivery_at_location = false
        @project.save
        @project.user.create_activity :submitted_delivery_false, owner: @project.user, recipient: @project
      end
      render json: { messages: ["اطلاعات با موفقیت ذخیره شد."] }.to_json, result: "True", status: :accepted
    end
  end

  private

  def find_photographer
    if params[:photographer_id].present?
      @photographer = Photographer.find params[:photographer_id]
    end
  end

  def reserve_params
    params.require(:reserve).permit(:offset_package, :photographer_id, :shoot_type_id, :package_id, :coupon_id, :user_id, :receipt_id, :address_id, :start_time, :delivery_at_location)
  end

  def coupons_params
    params.require(:coupon).permit(:code)
  end

  def addresses_params
    params.require(:address).permit(:longtitude, :lattitude, :input, :detail, :in_studio)
  end

  def shoot_type_params
    params.require(:shoot_type).permit(:id)
  end

  def photographer_params
    params.require(:photographer).permit(:id, :price)
  end

  def detail_params
    params.require(:detail).permit(:shoot_detail, :feedback_channel_id)
  end
end
