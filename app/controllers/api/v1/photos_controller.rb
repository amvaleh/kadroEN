class Api::V1::PhotosController < ApiController
  include Swagger::Docs::Methods
  respond_to :json

  def create
    result = Photos::PhotoCreate.call(data: params)
    if result.success?
      photo_json = ActiveModelSerializers::SerializableResource.new(
            result.photo, each_serializer: PhotoSerializer).as_json
      render json: Rw::SuccessResponse.call(object_name: 'data',
                                               response_object: photo_json,
                                               additional_json: nil).result
    else
      render json: {errors: result.errors}, status: :bad_request
    end
  end

  def destroy
    result = Photos::PhotoDestroy.call(id: params[:id], photographer: @photographer)
    if result.success?
      render json: Rw::SuccessResponse.call().result
      # render json: {messages: I18n.t(:'photos.messages.deleted_successfully')}, result: "True",status: :accepted
    else
      render json: {errors: result.errors}, status: :bad_request
    end
  rescue Exception => e
    render json: {errors: e.message}, status: :bad_request
  end
end
