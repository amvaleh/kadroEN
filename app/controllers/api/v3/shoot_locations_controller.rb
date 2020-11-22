class Api::V3::ShootLocationsController < ApiController
  skip_before_action :authenticate_token
  respond_to :json

  def give_all_studios
    if params["shoot_type_id"].present?
      shoot_locations = ShootLocations::GiveStudiosWithShootType.call(shoot_type_id: params["shoot_type_id"]).shoot_locations
    else
      shoot_locations = ShootLocation.all.where(:approved => true, :is_studio => true)
    end
    shoot_locations_json = ActiveModelSerializers::SerializableResource.new(
        shoot_locations, each_serializer: ShootLocationSerializer).as_json
    render json: { shoot_locations: shoot_locations_json, message: ["نتیجه یافت شد."] }.to_json, status: :accepted
  end

  def give_all_locations
    if params["shoot_type_id"].present?
      shoot_locations = ShootLocations::GiveShootLocationsWithShootType.call(shoot_type_id: params["shoot_type_id"]).shoot_locations
    else
      shoot_locations = ShootLocation.all.where(:approved => true, :is_studio => false)
    end
    shoot_locations_json = ActiveModelSerializers::SerializableResource.new(
        shoot_locations, each_serializer: ShootLocationSerializer).as_json
    render json: { shoot_locations: shoot_locations_json, message: ["نتیجه یافت شد."] }.to_json, status: :accepted
  end
end
