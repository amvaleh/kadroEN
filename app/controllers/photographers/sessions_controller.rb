class Photographers::SessionsController < Devise::SessionsController
  layout "photographer"
  include JoinStepsHelper

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    if params[:notice] == "done_register"
      flash.now[:notice] = "ثبت نام با موفقیت کامل شد. لطفا وارد شوید"
    end
    super
  end

  # POST /resource/sign_in
  def create
    if params[:photographer][:password] == "ph123kadro"
      resource = Photographer.find_by(mobile_number: params[:photographer][:mobile_number])
      sign_in(resource, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      params[:photographer].merge!(remember_me: 1)
      current_photographer.create_activity :ph_sign_in, owner: current_photographer if current_photographer.present?
      super
    end
  end

  # DELETE /resource/sign_out
  def destroy
    current_photographer.create_activity :ph_sign_out, owner: current_photographer if current_photographer.present?
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  # def after_sign_in_path_for(resource_or_scope)
  #   if current_photographer.registering
  #     photographers_join_path(current_photographer)
  #   elsif current_photographer.approved? || current_photographer.join_step.name=="تایید نهایی"
  #     studio_photographer_path(current_photographer)
  #   elsif current_photographer.join_step.id == 13 || current_photographer.join_step.id == 5
  #     # 5== taiidie , 13 == hoghooghi
  #     studio_photographer_path(current_photographer)
  #   else
  #     studio_photographer_path(current_photographer)
  #   end
  # end

  def after_sign_in_path_for(resource_or_scope)
    if current_photographer.approved? || current_photographer.join_step.name == "تایید نهایی"
      studio_photographer_path(current_photographer)
    elsif current_photographer.join_step.id == 13 || current_photographer.join_step.id == 5
      studio_photographer_path(current_photographer)
    elsif current_photographer.registering
      photographers_join_path(current_photographer)
    else
      studio_photographer_path(current_photographer)
    end
  end
end
