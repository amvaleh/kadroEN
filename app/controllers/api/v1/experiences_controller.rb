class Api::V1::ExperiencesController < ApiController
  include Swagger::Docs::Methods
  respond_to :json

  def create
    result = Experiences::ExperienceCreate.call(data: experiences_params)
    if result.success?
      render json: Rw::SuccessResponse.call(object_name: "experience_id",
                                            response_object: result.experience.id,
                                            additional_json: nil).result
    else
      render json: { errors: result.errors }, status: :bad_request
    end
  end

  private

  def experiences_params
    params.require(:experience).permit(:years_been_photographer, :has_payed_work, :projects_payed_count, :self_describe, :bio, :passion, :love_job, :favorite_shoots, :shoots, :city_shoots, :awards, :fun_fact, :photographer_id)
  end
end
