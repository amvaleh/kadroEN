class SubdomainController < ApplicationController
  layout "kadro"
  before_action :ensure_photographer!

  def show
    redirect_to @photographer.pro_url
    # @photographer
  end

  def ensure_photographer!
    @photographer ||= Photographer.find_by uid: request.subdomain
    head(:not_found) if @photographer.nil?
    @photographer
  end
  #
  # def current_photographer
  #   @photographer
  # end

end
