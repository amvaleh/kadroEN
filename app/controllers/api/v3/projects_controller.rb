class Api::V3::ProjectsController < ApiController
  skip_before_action :authenticate_token
  respond_to :json

  def give_projects_slug
    @projects = Projects::FindProjectBySlug.call(slug: params[:slug]).projects
    @final_projects = ActiveModelSerializers::SerializableResource.new(@projects, each_serializer: ProjectSlugSerializer).as_json
    if @final_projects.any?
      render json: { projects: @final_projects, message: ["نتیجه یافت شد."] }.to_json, status: :accepted
    else
      render json: { errors: ["متاسفانه پروژه ای یافت نشد."] }, status: :bad_request
    end
  end

  private

  def project_params
    params.require(:project).permit(:id, :slug)
  end
end
