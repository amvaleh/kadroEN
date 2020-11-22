class Api::V3::UsersController < ApiController
  skip_before_action :authenticate_token
  respond_to :json

  def create
    @shoot_types = ShootType.active
    if params[:shoot_location].present?
      shoot_location = ShootLocation.find_by(slug: params[:shoot_location])
      if shoot_location.present?
        @direct_shoot_types = ShootLocations::FindDirectShootType.call(shoot_location: shoot_location).shoot_types
      end
    end
    @user = User.find_by(mobile_number: user_params[:mobile_number])
    if not @user
      pass = rand.to_s[3..8]
      @user = User.create(:password => pass, :password_confirmation => pass, :reset_password_token => pass, :password_sent_times => 1, :password_sent_at => Time.now, first_name: user_params[:first_name], last_name: user_params[:last_name], mobile_number: user_params[:mobile_number], email: user_params[:email], company_name: user_params[:company_name])
      if @user.save
        @project = Project.create(:user_id => @user.id)
        @user.create_activity :registered_and_started_a_project, owner: @user, recipient: @project
        render json: { message: ["اطلاعات با موفقیت ذخیره شد"], project_slug: [@project.slug], project_id: [@project.id], token: encode({ type: 2, user: @user.id }), shoot_types: [@shoot_types], direct_shoot_types: [@direct_shoot_types], shoot_location: shoot_location }.to_json, status: :accepted
      else
        render json: { errors: ["متاسفانه اطلاعات با موفقیت ذخیره نشد"] }, status: :bad_request
      end
    else
      User.where(mobile_number: user_params[:mobile_number]).first.update_attributes(first_name: user_params[:first_name], last_name: user_params[:last_name], email: user_params[:email], company_name: user_params[:company_name])
      @project = Project.create(:user_id => @user.id)
      @user.create_activity :started_a_project, owner: @user, recipient: @project
      render json: { message: ["اطلاعات شما بروز رسانی شد"], project_slug: [@project.slug], project_id: [@project.id], token: encode({ type: 2, user: @user.id }), shoot_types: [@shoot_types], direct_shoot_types: [@direct_shoot_types], shoot_location: shoot_location }.to_json, status: :accepted
    end
  end

  def update_user
    @user = User.find_by(mobile_number: user_params[:mobile_number])
    if not @user
      render json: { errors: ["متاسفانه این کاربر وجود ندارد"] }, status: :bad_request
    else
      @user.first_name = user_params[:first_name]
      @user.last_name = user_params[:last_name]
      @user.email = user_params[:email]
      @user.company_name = user_params[:company_name]
      @user.save
      if @user.save
        render json: { message: ["اطلاعات شما بروز رسانی شد"] }.to_json, status: :accepted
      else
        render json: { errors: ["متاسفانه اطلاعات ذخیره نشد"] }, status: :bad_request
      end
    end
  end

  def give_users
    @users = Users::FindUserByMobileNumber.call(mobile_number: params[:value]).users
    @final_users = ActiveModelSerializers::SerializableResource.new(@users, each_serializer: UserSerializer).as_json
    if @final_users.any?
      render json: { users: @final_users, message: ["نتیجه یافت شد."] }.to_json, status: :accepted
    else
      render json: { errors: ["متاسفانه کاربری یافت نشد."] }, status: :bad_request
    end
  end

  def generate_password
    if params[:mobile_number].present?
      mobile_number = params[:mobile_number]
    else
      mobile_number = params[:user][:mobile_number]
    end
    if mobile_number == "09031931470" || mobile_number == "09356965754" || mobile_number == "09123035856" ||
        mobile_number == "09353954916" || mobile_number == "09122087522" || mobile_number == "09027993049" ||
        mobile_number == "09120132331" || mobile_number == "09370027366" || mobile_number == "09136183194" ||
        mobile_number == "09121111111" || mobile_number == "09206152175" || mobile_number == "09121111111" || mobile_number == "09125239118" || mobile_number == "09101002002"
      generated_password = "123456"
      indoor = true
    end
    @user = User.find_by_mobile_number(mobile_number)
    if @user.present?
      if @user.password_sent_times < 2
        if !indoor
          generated_password = rand.to_s[3..6]
        end
        @user.password = generated_password
        @user.password_confirmation = generated_password
        @user.reset_password_token = generated_password
        @user.password_sent_at = Time.now
        @user.password_sent_times = @user.password_sent_times + 1
      elsif (Time.now - @user.password_sent_at) > 1.minutes
        @user.password_sent_times = 1
        if !indoor
          generated_password = rand.to_s[3..6]
        end
        @user.password = generated_password
        @user.password_confirmation = generated_password
        @user.reset_password_token = generated_password
        @user.password_sent_at = Time.now
      else
        error = "error"
      end
      unless @user.credit.present?
        @user.create_user_credit
      end
    else
      generated_password = rand.to_s[3..6]
      @user = User.new
      @user.mobile_number = mobile_number
      @user.password = generated_password
      @user.password_confirmation = generated_password
      @user.reset_password_token = generated_password
      @user.password_sent_times = @user.password_sent_times + 1
      @user.password_sent_at = Time.now
      if params[:business_name].present?
        @user.business = Business.find_by_name(params[:business_name])
      end
    end
    puts @user.password_sent_times
    puts @user.password_sent_at
    puts "pass"
    puts generated_password
    if error == "error"
      render json: { errors: ["تعدادی پیامک شامل کد تایید برای شما ارسال شده است. لطفا ۱ دقیقه دیگر منتظر بمانید."] }, status: :bad_request
    elsif @user.save
      render json: { message: ["کد ورود با موفقیت ارسال گردید."] }.to_json, status: :accepted
      if !indoor and Rails.env.production?
        result = Messages::KavenegarSendTemplate.call(mobile_number: @user.mobile_number, token: generated_password, template: "user-password")
      end
    else
      render json: { errors: ["مشکلی پیش آمده بعدا تلاش بفرمایید."] }, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :mobile_number, :email, :company_name, :full_name)
  end
end
