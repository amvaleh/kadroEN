class Api::V1::UsersController < ApiController
  skip_before_action :authenticate_token
  respond_to :json


  include Swagger::Docs::Methods


  swagger_controller :registrations, "Registrations"



  swagger_api :create do |api|
    summary "Creates a new User & return Shoot_types"
    Api::V1::UsersController::add_common_params(api)
    response :accepted
    response :bad_request
  end

  swagger_api :update_user do |api|
    summary "Update a User"
    Api::V1::UsersController::update_params(api)
    response :accepted
    response :bad_request
  end

  def self.add_common_params(api)
    api.param :form, "user[first_name]", :string, :required, "Notes"
    api.param :form, "user[last_name]", :string, :required, "Name"
    api.param :form, "user[email]", :string, :required, "Email"
    api.param :form, "user[mobile_number]", :string, :required, "Mobile Number"
    api.param :form, "user[company_name]", :string, :require, "Company Name"
  end

  def self.update_params(api)
    api.param :header, "Authorization", :string, :required, "Authorization"
    api.param :form, "user[first_name]", :string, :required, "Notes"
    api.param :form, "user[last_name]", :string, :required, "Name"
    api.param :form, "user[email]", :string, :required, "Email"
    api.param :form, "user[mobile_number]", :string, :required, "Mobile Number"
    api.param :form, "user[company_name]", :string, :require, "Company Name"
  end


  def create
    @shoot_types = ShootType.active
    @user = User.find_by(mobile_number: user_params[:mobile_number])
    if not @user
      pass = rand.to_s[3..8]
      @user = User.create(:password=>pass ,:password_confirmation=>pass,:reset_password_token=>pass,:password_sent_times=>1,:password_sent_at=>Time.now, first_name:user_params[:first_name] , last_name:user_params[:last_name] , mobile_number:user_params[:mobile_number] , email:user_params[:email] , company_name:user_params[:company_name])
      if @user.save
        @project = Project.create(:user_id => @user.id)
        @user.create_activity :registered_and_started_a_project, owner: @user, recipient: @project
        render json: {message:["اطلاعات با موفقیت ذخیره شد"],project_slug: [@project.slug],token:encode({type:2,user:@user.id}),shoot_types:[@shoot_types]}.to_json, status: :accepted
      else
        render json:{errors:["متاسفانه اطلاعات با موفقیت ذخیره نشد"]},status: :bad_request
      end
    else
      User.where(mobile_number: user_params[:mobile_number]).first.update_attributes(first_name:user_params[:first_name] , last_name:user_params[:last_name] , email:user_params[:email] , company_name:user_params[:company_name])
      @project = Project.create(:user_id => @user.id)
      @user.create_activity :started_a_project, owner: @user, recipient: @project
      render json: {message:["اطلاعات شما بروز رسانی شد"],project_slug: [@project.slug],token:encode({type:2,user:@user.id}),shoot_types:[@shoot_types]}.to_json, status: :accepted
    end
  end

  def update_user
    @user = User.find_by(mobile_number: user_params[:mobile_number])
    if not @user
      render json:{errors:["متاسفانه این کاربر وجود ندارد"]},status: :bad_request
    else
      @user.first_name = user_params[:first_name]
      @user.last_name = user_params[:last_name]
      @user.email = user_params[:email]
      @user.company_name = user_params[:company_name]
      @user.save
      if @user.save
        render json: {message:["اطلاعات شما بروز رسانی شد"]}.to_json, status: :accepted
      else
        render json:{errors:["متاسفانه اطلاعات ذخیره نشد"]},status: :bad_request
      end
    end
  end


  private
  def user_params
    params.require(:user).permit(:first_name,:last_name,:mobile_number,:email,:company_name)
  end
end
