class Api::V2::ProjectsController < ApiController
  before_action :find_project
  respond_to :json

  def submit_photographer
    unless photographer_params[:id]
      render json: { errors: ["لطفا پارامتر رشته انتخابی را درست وارد نمایید"] }.to_json, status: :bad_request
      return
    end
    if @project.search_for_studio
      shoot_location = ShootLocation.find_by(:is_studio => true, :photographer_id => photographer_params[:id])
      address = @project.address
      address.lattitude = shoot_location.address.lattitude
      address.longtitude = shoot_location.address.longtitude
      address.input = shoot_location.address.input
      address.detail = shoot_location.address.detail
      address.save
    end
    Project.where(id: @project.id).update_all(photographer_id: photographer_params[:id])
    @project.set_reserve_step("photographer")
    @project.save
    project_candidate = ProjectCandidate.find_by(project_id: @project.id, photographer_id: photographer_params[:id])
    candidates = @project.project_candidates
    candidates.update_all(:project_candidate_status_id => ProjectCandidateStatus.find_by_title("elected").id)
    project_candidate.project_candidate_status = ProjectCandidateStatus.find_by_title("waiting")
    price = project_candidate.price
    receipt = @project.receipt
    if receipt.transportion_cost > 0
      receipt.subtotal = (receipt.subtotal.to_f - receipt.transportion_cost).to_i
      receipt.total = (receipt.total.to_f - receipt.transportion_cost).to_i
      receipt.transportion_cost = 0
    end
    receipt.transportion_cost = price
    receipt.subtotal = (receipt.subtotal.to_f + price).to_i
    receipt.total = (receipt.total.to_f + price).to_i
    receipt.save
    project_candidate.save
    @project.create_activity :submitted_photographer, owner: @project.user, recipient: Photographer.where(id: photographer_params[:id])[0]
    @feedback = FeedbackChannel.all
    render json: { feedback: [@feedback] }, result: "True", status: :accepted
  end

  private

  def photographer_params
    params.require(:photographer).permit(:id)
  end
end
