class Api::V2::FreeTimesController < ApiController
  before_action :find_project, :authenticate_token
  respond_to :json

  def available_hours
    unless free_time_params[:date]
      render json: "مقدار تاریخ نامعتبر است".to_json, status: :bad_request
    end
    date = DateTime.parse(free_time_params[:date]).strftime("%Y-%m-%d").to_date
    result = FreeTimes::FreeTimeSearch.call(project: @project, date: date)
    # result = FreeTimes::FreeTimesToPhotographers.call(free_times: result.free_times)
    # project = ProjectCandidates::ProjectCandidateDestroy.call(project: @project)
    # result = ProjectCandidates::ProjectCandidateCreate.call(data: result, project: @project)
    result = FreeTimes::AvailableTimesSearch.call(data: result, date: date, project: @project)
    if !result.morning.any? && !result.afternoon.any? && !result.evening.any?
      effect = []
      effect = { response: "nok" }
    else
      effect = []
      effect = { response: "ok", result: [
        { time_name: "صبح", times: result.morning },
        { time_name: "ظهر", times: result.afternoon },
        { time_name: "شب", times: result.evening },
      ] }
    end
    # result = ProjectCandidates::SetPriority.call(data: result, project: @project)
    render json: effect.to_json, status: :accepted
  end

  def available_photographer_hours
    unless free_time_params[:date]
      render json: "مقدار تاریخ نامعتبر است".to_json, status: :bad_request
    end
    date = DateTime.parse(free_time_params[:date]).strftime("%Y-%m-%d").to_date

    free_times_present = FreeTimes::FreeTimeSearch.call(project: @project, date: date)
    photographers_with_free_times = FreeTimes::FreeTimesToPhotographers.call(free_times: free_times_present.free_times)
    project = ProjectCandidates::ProjectCandidateDestroy.call(project: @project)
    potential_candidates = ProjectCandidates::ProjectCandidateCreate.call(data: photographers_with_free_times, project: @project, photographer_uid: params[:photographer])
    direct_free_times_present = FreeTimes::FreeTimeSearch.call(project: @project, date: date, photographer_uid: params[:photographer])
    direct_photographers_with_free_times = FreeTimes::FreeTimesToPhotographers.call(free_times: direct_free_times_present.free_times)
    direct_potential_candidates = ProjectCandidates::ProjectCandidateCreate.call(data: direct_photographers_with_free_times, project: @project, photographer_uid: params[:photographer])

    result = FreeTimes::AvailableTimesSearch.call(data: direct_potential_candidates, date: date, project: @project)
    if !result.morning.any? && !result.afternoon.any? && !result.evening.any?
      effect = []
      effect = { response: "nok" }
    else
      effect = []
      effect = { response: "ok", result: [
        { time_name: "صبح", times: result.morning },
        { time_name: "ظهر", times: result.afternoon },
        { time_name: "شب", times: result.evening },
      ] }
    end
    result = ProjectCandidates::SetPriority.call(data: result, project: @project, direct: true)
    render json: effect.to_json, status: :accepted
  end

  private

  def free_time_params
    params.require(:free_time).permit(:day, :start, :end, :package_id, :shoot_type, :date)
  end
end
