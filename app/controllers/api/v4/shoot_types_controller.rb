class Api::V4::ShootTypesController < ApiController
  skip_before_action :authenticate_token
  respond_to :json

  def index
    shoot_types = ShootType.active
    shoot_types_json = ActiveModelSerializers::SerializableResource.new(
      shoot_types, each_serializer: ShootTypeV2Serializer,
    ).as_json

    render json: { shoot_types: shoot_types_json }.to_json, status: :accepted
  end
end
