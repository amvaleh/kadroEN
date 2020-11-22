class Api::V1::EquipmentsController < ApiController
  include Swagger::Docs::Methods
  respond_to :json

  def create
    result = Equipments::EquipmentCreate.call(data: params)
    if result.success?
      all_shoot_types = ShootType.all
      shoot_types_json = ActiveModelSerializers::SerializableResource.new(
            all_shoot_types, each_serializer: ShootTypeSerializer).as_json
      render json: Rw::SuccessResponse.call(object_name: 'shoot_types',
                                               response_object: shoot_types_json,
                                               additional_json: nil).result
    else
      render json: {errors: result.errors}, status: :bad_request
    end

  end
end
