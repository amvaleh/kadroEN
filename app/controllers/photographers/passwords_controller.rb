class Photographers::PasswordsController < Devise::PasswordsController
  layout 'photographer'
  include JoinStepsHelper

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  def after_resetting_password_path_for(resource)
    photographer_next_join_step(resource)
  end



  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_photographer_session_path
  end
end
