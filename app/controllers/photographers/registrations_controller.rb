class Photographers::RegistrationsController < Devise::RegistrationsController
  
  layout 'wordpress'

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    # redirect_to photographers_apply_path
  end

  # POST /resource
  def create
    # super:

    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      # set_flash_message! :notice, :"خطا در ذخیره سازی اطلاعات، لطفا مجدد تلاش کنید."
      # redirect_to photographers_apply_path , :notice => "خطا در ذخیره سازی اطلاعات، لطفا مجدد تلاش کنید."
      resource.errors.full_messages.each {|x| flash[x] = x}
      redirect_to apply_path
      # response_to_sign_up_failure resource
      # respond_with resource , location: photographers_apply_path
    end
    # end of submit_page_form
    @photographer.first_name = params[:photographer][:first_name]
    @photographer.last_name = params[:photographer][:last_name]
    @photographer.email = params[:photographer][:email]
    @photographer.static_number = params[:photographer][:static_number]
    @photographer.mobile_number = params[:photographer][:full_phone]
    @photographer.join_step_id = JoinStep.find_by_name("primary_info").id
    #location:
    location = Location.new
    location.living_address = params[:photographer][:living_address]
    location.living_long = params[:photographer][:living_long]
    location.living_lat = params[:photographer][:living_lat]
    location.working_lat = params[:photographer][:working_lat]
    location.working_long = params[:photographer][:working_long]
    location.living_input = params[:photographer][:living_input]
    location.working_input = params[:photographer][:working_input]
    location.save
    @photographer.location = location

    #
    @photographer.unconfirmed_email = params[:photographer][:email]
    if @photographer.save
      DeviseWorker.perform_async(@photographer.id)
    end

  end

  # GET /resource/edit
  def edit
    unless photographer_signed_in?
      redirect_to redirect_to photographers_apply_path
    end
    super
  end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
        :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      bypass_sign_in resource, scope: resource_name
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:living_lat,:living_long,:working_lat,:working_long ,:attribute, :mobile_number,:first_name,:last_name,:static_number,:email,:ideal_hours])
  end


  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    # studio_photographer_path(resource)
    if current_photographer.uid.present?
      studio_photographer_path(resource)
    else
      projects_photographer_path(resource)
    end
  end

  def after_update_path_for(resource)
    studio_photographer_path(resource)
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
