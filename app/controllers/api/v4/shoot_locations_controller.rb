class Api::V4::ShootLocationsController < ApiController
  skip_before_action :authenticate_token
  respond_to :json

  def index
    if params["shoot_type_id"].present?
      shoot_location_studios = ShootLocations::GiveStudiosWithShootType.call(shoot_type_id: params["shoot_type_id"]).shoot_locations
      shoot_locations = ShootLocations::GiveShootLocationsWithShootType.call(shoot_type_id: params["shoot_type_id"]).shoot_locations
    else
      shoot_location_studios = ShootLocation.all.where(:approved => true, :is_studio => true)
      shoot_locations = ShootLocation.all.where(:approved => true, :is_studio => false)
    end
    cities = ActiveCity.all
    shoot_locations_json = ActiveModelSerializers::SerializableResource.new(
      shoot_locations, each_serializer: ShootLocationSerializer,
    ).as_json
    shoot_location_studios_json = ActiveModelSerializers::SerializableResource.new(
      shoot_location_studios, each_serializer: ShootLocationSerializer,
    ).as_json
    render json: { shoot_locations: shoot_locations_json, studios: shoot_location_studios_json, cities: cities }.to_json, status: :accepted
  end
end
