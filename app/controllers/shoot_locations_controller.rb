class ShootLocationsController < ApplicationController
  before_action :set_url
  layout "shoot_location"

  def index
    @shoot_locations = ShootLocation.where(approved: true).not_studio
    @shoot_types = ShootTypes::SelectShootTypesHaveShootLocation.call().shoot_types
  end

  def show
    @shoot_location = ShootLocation.find_by(slug: params[:id])
    @shoot_type_locations = ShootTypeLocation.joins(:shoot_location).where(:shoot_locations => { slug: params[:id] })
    @owner_shoot_location_photographer = @shoot_location.photographer
    if @shoot_location.photographer.present? && @shoot_location.is_studio
      @suggested_photographers = Photographer.where(:id => @shoot_location.photographer.id)
    elsif @shoot_location.shoot_type_locations.present?
      shoot_type_ids = @shoot_location.shoot_type_locations.map(&:shoot_type_id.to_proc)
      @suggested_photographers = ShootLocations::FindTheBestPhotographer.call(shoot_type_ids: shoot_type_ids, latitude: @shoot_location.address.lattitude.to_f, longitude: @shoot_location.address.longtitude.to_f).photographers
    end
    @title = @shoot_location.title + " - " + " مکان عکاسی برتر"
  end

  def shoot_type_filter
    @shoot_locations = ShootLocation.joins(:shoot_type_locations => :shoot_type).where(:shoot_types => { title: params[:shoot_type] }, approved: true)
    @shoot_types = ShootTypes::SelectShootTypesHaveShootLocation.call().shoot_types - ShootType.where(title: params[:shoot_type])
    @shoot_type = ShootType.find_by(title: params[:shoot_type])
    @title = @shoot_locations.count.to_s + " مکان عکاسی برتر " + " برای عکاسی " + @shoot_type.title
  end

  def shoot_location_type
    @shoot_locations = ShootLocation.joins(:shoot_location_type).where(:shoot_location_types => { title: params[:id] })

    @shoot_location_type = ShootLocationType.find_by(title: params[:id])
    # @shoot_locations = ShootLocation.joins(:shoot_type_locations => :shoot_type).where(:shoot_types => {title: params[:shoot_type]}, approved: true )
    @shoot_types = ShootTypes::SelectShootTypesHaveShootLocation.call().shoot_types - ShootType.where(title: params[:shoot_type])
    # @shoot_type = ShootType.find_by(title: params[:shoot_type])
    @title = @shoot_locations.count.to_s + " مکان عکاسی " + " - " + @shoot_location_type.title
  end

  private

  def set_url
    if Rails.env.production?
      @base_url = "https://app.kadro.me/"
      @sub_url = "https://locations.kadro.me/"
    elsif Rails.env.development?
      @base_url = "http://app.localhost:3000/"
      @sub_url = "http://locations.localhost:3000/"
    end
  end
end
