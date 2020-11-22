class ApplicationController < ActionController::Base
  after_action :track_action
  layout "wordpress", only: [:page_not_found]

  before_action :store_user_location!, if: :storable_location?
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  # rescue_from Rw::PermissionError, :with => :permission_exception

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :photographer
      new_photographer_session_path
    elsif resource_or_scope == :user
      kadro_url
    elsif resource_or_scope == :admin_user
      new_admin_user_session_path
    end
  end

  def page_not_found
    puts "page not found action called here!"
  end

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr? unless request.fullpath =~ /\/users/
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  protected

  def track_action
    # ahoy.track "Ran action", request.path_parameters
  end
end
