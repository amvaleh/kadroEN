class Api::V1::LocationsController < ApiController
  include Swagger::Docs::Methods
  respond_to :json

  def create
    result = Locations::LocationCreate.call(data: locations_params)
    if result.success?

      photographer = Photographer.find_by(id: locations_params[:photographer_id])
      photographer.create_activity :ph_join_location_info, owner: photographer, recipient: result.location

      cameras = Camera.all
      lenzs = Lenz.all
      kits = Kit.all
      cameras_json = ActiveModelSerializers::SerializableResource.new(
            cameras, each_serializer: CameraSerializer).as_json
      lenzs_json = ActiveModelSerializers::SerializableResource.new(
                  lenzs, each_serializer: LenzSerializer).as_json
      kits_json = ActiveModelSerializers::SerializableResource.new(
                  kits, each_serializer: KitSerializer).as_json
      data = cameras_json + lenzs_json + kits_json
      render json: Rw::SuccessResponse.call(object_name: 'data',
                                               response_object: data,
                                               additional_json: nil).result
    else
      render json: {errors: result.errors}, status: :bad_request
    end

  end

  private
  def locations_params
    params.require(:location).permit(:living_address, :living_long, :living_lat, :working_lat, :working_long, :living_input, :working_input, :photographer_id)
  end

end
