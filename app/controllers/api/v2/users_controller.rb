class Api::V2::UsersController < ApiController
  skip_before_action :authenticate_token
  respond_to :json


  include Swagger::Docs::Methods


  swagger_controller :registrations, "Registrations"



  swagger_api :create do |api|
    summary "Creates a new User & return Shoot_types"
    Api::V2::UsersController::add_common_params(api)
    response :accepted
    response :bad_request
  end

  swagger_api :update_user do |api|
    summary "Update a User"
    Api::V2::UsersController::update_params(api)
    response :accepted
    response :bad_request
  end

  def self.add_common_params(api)
    api.param :form, "user[full_name]", :string, :required, "Name"
    api.param :form, "user[mobile_number]", :string, :required, "Mobile Number"
  end

  def self.update_params(api)
    api.param :header, "Authorization", :string, :required, "Authorization"
    api.param :form, "user[full_name]", :string, :required, "Name"
    api.param :form, "user[mobile_number]", :string, :required, "Mobile Number"
  end


  def create
    @shoot_types = ShootType.active
    @user = User.find_by(mobile_number: user_params[:mobile_number])
    if not @user
      pass = rand.to_s[3..8]
      @user = User.create(:password=>pass ,:password_confirmation=>pass,:reset_password_token=>pass,:password_sent_times=>1,:password_sent_at=>Time.now, full_name:user_params[:full_name], mobile_number:user_params[:mobile_number] )
      if @user.save
        @project = Project.create(:user_id => @user.id)
        @user.create_activity :registered_and_started_a_project, owner: @user, recipient: @project
        render json: {message:["اطلاعات با موفقیت ذخیره شد"],project_slug: [@project.slug],token:encode({type:2,user:@user.id}),shoot_types:[@shoot_types]}.to_json, status: :accepted
      else
        render json:{errors:["متاسفانه اطلاعات با موفقیت ذخیره نشد"]},status: :bad_request
      end
    elsif not user_params[:mobile_number] == "09027993049"
      User.where(mobile_number: user_params[:mobile_number]).first.update_attributes(full_name:user_params[:full_name])
      @project = Project.create(:user_id => @user.id)
      @user.create_activity :started_a_project, owner: @user, recipient: @project
      render json: {message:["اطلاعات شما بروز رسانی شد"],project_slug: [@project.slug],token:encode({type:2,user:@user.id}),shoot_types:[@shoot_types]}.to_json, status: :accepted
    else
      User.where(mobile_number: user_params[:mobile_number]).first.update_attributes(full_name: "kadroTestUser")
      @project = Project.create(:user_id => @user.id)
      @user.create_activity :started_a_project, owner: @user, recipient: @project
      render json: {message:["اطلاعات شما بروز رسانی شد"],project_slug: [@project.slug],token:encode({type:2,user:@user.id}),shoot_types:[@shoot_types]}.to_json, status: :accepted
    end
  end

  def update_user
    # get project slug and reset it here.
    project = Project.friendly.find(params[:id])
    user = User.find_by(mobile_number: user_params[:mobile_number])
    # search if user exists
    if user
      if not user_params[:mobile_number] == "09027993049"
        user.full_name = user_params[:full_name]
      else
        user.full_name = "kadroTestUser"
      end
    else
      pass = rand.to_s[3..8]
      user = User.create(:password=>pass ,:password_confirmation=>pass, full_name:user_params[:full_name], mobile_number:user_params[:mobile_number])
    end
    project.user_id = user.id
    receipt = project.receipt
    receipt.user_id = user.id
    if project.save and user.save and receipt.save
      render json: {message:["اطلاعات پروژه به روزرسانی شد."]}.to_json, status: :accepted
    else
      render json:{errors:["متاسفانه اطلاعات ذخیره نشد"]},status: :bad_request
    end
  end


  private
  def user_params
    params.require(:user).permit(:mobile_number, :full_name)
  end
end
