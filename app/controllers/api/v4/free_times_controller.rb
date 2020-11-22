class Api::V4::FreeTimesController < ApiController
  skip_before_action :authenticate_token
  before_action :find_project
  respond_to :json

  def available_hours
    unless params[:date]
      render json: { error: "Bad Request!" }.to_json, status: :bad_request
    end
    date = DateTime.parse(params[:date]).strftime("%Y-%m-%d").to_date
    if @project.photographer.present? and @project.direct_book?
      free_times_present = FreeTimes::FreeTimeSearch.call(project: @project, date: date)
      photographers_with_free_times = FreeTimes::FreeTimesToPhotographers.call(free_times: free_times_present.free_times)
      project = ProjectCandidates::ProjectCandidateDestroy.call(project: @project)
      potential_candidates = ProjectCandidates::ProjectCandidateCreate.call(data: photographers_with_free_times, project: @project, photographer_uid: params[:photographer])
      direct_free_times_present = FreeTimes::FreeTimeSearch.call(project: @project, date: date, photographer_uid: params[:photographer])
      direct_photographers_with_free_times = FreeTimes::FreeTimesToPhotographers.call(free_times: direct_free_times_present.free_times)
      direct_potential_candidates = ProjectCandidates::ProjectCandidateCreate.call(data: direct_photographers_with_free_times, project: @project, photographer_uid: params[:photographer])
      result = FreeTimes::AvailableTimesSearch.call(data: direct_potential_candidates, date: date, project: @project)
      result_priority = ProjectCandidates::SetPriority.call(data: result, project: @project, direct: true)
    else
      result = FreeTimes::FreeTimeSearch.call(project: @project, date: date)
      result = FreeTimes::AvailableTimesSearch.call(data: result, date: date, project: @project)
    end
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
    render json: effect.to_json, status: :accepted
  end
end
