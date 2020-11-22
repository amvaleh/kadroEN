class Users::SessionsController < Devise::SessionsController

  include UsersHelper

  prepend_before_action :require_no_authentication, only: [:new, :create]
  prepend_before_action :allow_params_authentication!, only: :create
  prepend_before_action :verify_signed_out_user, only: :destroy
  prepend_before_action(only: [:create, :destroy]) {request.env["devise.skip_timeout"] = true}

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    # debugger
    if params[:mobile_number].nil? && params[:user].nil?
      redirect_to users_register_path
    else
      @mobile_number = params[:mobile_number] ? params[:mobile_number] : params[:user][:mobile_number]
      @slug = User.where(mobile_number: @mobile_number).pluck(:slug)[0]
    end
    # unless params[:mobile_number].nil? && params[:user].nil?
    #   @mobile_number = params[:mobile_number] ? params[:mobile_number] : params[:user][:mobile_number]
    #   redirect_to users_register_path
    # end
  end

  # POST /resource/sign_in
  def create
    session[:tries] = nil

    @user = current_user
    # debugger
    unless @user.nil? or @user.first_name.nil? or @user.last_name.nil?
      @user.create_activity :sign_in, owner: current_user
    end
    resource = User.find_by_mobile_number(params[:user][:mobile_number])
    self.resource = User.find_by_mobile_number(params[:user][:mobile_number])
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)

    unless sign_in(resource_name, resource)
      @error = 'کد وارد شده اشتباه است.'
    end
    yield resource if block_given?

    respond_with resource, location: after_sign_in_path_for(resource)
  end

  # DELETE /resource/sign_out
  def destroy
    @user = current_user
    unless @user.nil? or @user.first_name.nil? or @user.last_name.nil?
      @user.create_activity :sign_out, owner: current_user
    end
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    respond_to_on_destroy
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected



  def after_sign_in_path_for(resource_or_scope)
    if params[:user][:business_name].present?
      business = Business.find_by_name(params[:user][:business_name])
      # redirect_to business_projects_path(business.name,request.params)
      user_next_join_step(resource_or_scope, business.name, request.params)
    else
      stored_location_for(resource_or_scope) || super
      # package_projects_path
    end
    # byebug
  end

  protected

  def sign_in_params
    devise_parameter_sanitizer.sanitize(:sign_in)
  end

  def serialize_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    {methods: methods, only: [:password]}
  end

  def auth_options
    {scope: resource_name, recall: "#{controller_path}#new"}
  end

  def translation_scope
    'devise.sessions'
  end

  private

  # Check if there is no signed in user before doing the sign out.
  #
  # If there is no signed in user, it will set the flash message and redirect
  # to the after_sign_out path.
  def verify_signed_out_user
    if all_signed_out?
      set_flash_message! :notice, :already_signed_out

      respond_to_on_destroy
    end
  end

  def all_signed_out?
    users = Devise.mappings.keys.map {|s| warden.user(scope: s, run_callbacks: false)}

    users.all?(&:blank?)
  end

  def respond_to_on_destroy
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all {head :no_content}
      format.any(*navigational_formats) {redirect_to after_sign_out_path_for(resource_name)}
    end
  end


  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end


end
