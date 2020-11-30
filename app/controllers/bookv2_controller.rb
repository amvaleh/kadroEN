class Bookv2Controller < ApplicationController
  before_action :authenticate_user!, only: [:show]

  layout "book"

  def show
    if params[:direct]
      @studio_lat = params[:studio_lat]
      @studio_lng = params[:studio_lng]
      @has_studio = params[:has_studio]
      @direct = params[:direct]
      @shoot_type = params[:shoot_type]
      @shoot_type_title = ShootType.find(params[:shoot_type]).title
      @photographer_uid = params[:photographer]
    else
      @studio_lat = nil
      @studio_lng = nil
      @has_studio = false
      @direct = false
      @shoot_type = nil
      @shoot_type_title = nil
      @photographer_uid = nil
    end
    @kadro = ""
    if Rails.env.production?
      @kadro = "https://app.kadro.me"
    elsif Rails.env.development?
      @kadro = "http://app.localhost:3000"
    elsif Rails.env.staging?
      @kadro = "http://185.53.143.141:3005"
    end
  end

  def callbook
    if params[:direct]
      @studio_lat = params[:studio_lat]
      @studio_lng = params[:studio_lng]
      @has_studio = params[:has_studio]
      @direct = params[:direct]
      @shoot_type = params[:shoot_type]
      @shoot_type_title = ShootType.find(params[:shoot_type]).title
      @photographer_uid = params[:photographer]
    else
      @studio_lat = nil
      @studio_lng = nil
      @has_studio = false
      @direct = false
      @shoot_type = nil
      @shoot_type_title = nil
      @photographer_uid = nil
    end
    @kadro = ""
    if Rails.env.production?
      @kadro = "https://app.kadro.me"
    elsif Rails.env.development?
      @kadro = "http://app.localhost:3000"
    elsif Rails.env.staging?
      @kadro = "http://185.53.143.141:3005"
    end
  end
end
