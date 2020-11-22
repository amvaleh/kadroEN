class Api::V4::PhotographersController < ApiController
  before_action :find_project
  before_action :authenticate_token, except: [:available_photographer]
  include ReserveHelper
  respond_to :json

  def available_photographer
    duration = helpers.convert_package_duration_number(Project.find_by(id: @project.id).package.duration) # package duration
    if duration == 0
      render json: "مقدار زمان انتخابی معتبر نیست".to_json, status: :bad_request
      return
    end
    unless photographers_params[:date]
      render json: "مقدار تاریخ نامعتبر است".to_json, status: :bad_request
      return
    end

    date = photographers_params[:date]
    week_day = helpers.convert_persian_number_day(date.to_date.to_pdate.strftime("%A"), false)
    @project.start_date = date.to_date
    @project.start_time = date.in_time_zone("Tehran").in_time_zone("UTC")
    @project.set_reserve_step("date")
    @project.save
    @project.user.create_activity :set_date_time, owner: @project.user, recipient: @project

    unless @project.direct_book?
      date1 = DateTime.parse(photographers_params[:date]).strftime("%Y-%m-%d").to_date
      result1 = FreeTimes::FreeTimeSearch.call(project: @project, date: date1)
      result1 = FreeTimes::FreeTimesToPhotographers.call(free_times: result1.free_times)
      project = ProjectCandidates::ProjectCandidateDestroy.call(project: @project)
      result1 = ProjectCandidates::ProjectCandidateCreate.call(data: result1, project: @project)
    end

    result = ProjectCandidates::ProjectCandidateSearch.call(project: @project)
    result = ProjectCandidates::ProjectCandidateToFreeTimes.call(week_day: week_day, project_candidates: result.project_candidates)
    result = Photographers::PhotographerSearchByTime.call(data: result, date: date, project: @project)
    result.overlap_items.each do |overlap_item|
      ProjectCandidates::ProjectCandidateDestroy.call(project: @project, id: overlap_item.id)
    end
    result = ProjectCandidates::SetPriority.call(data: result, project: @project)
    result.photographers.each do |photographer|
      Photographers::Analyze::MakeShootSuggestion.call(photographer_id: photographer.id, project_id: @project.id, user_id: @project.user_id, cookies: cookies)
    end
    #set visit time in cookie
    set_cookie
    #Returns back list of available times
    render json: { data: result.final_photographers.first(7), success: true }, status: :accepted
  end

  private

  def photographers_params
    params.require(:photographer).permit(:date, :first_name, :last_name, :mobile_number,
                                         :static_number, :email, :password, :ideal_hours,
                                         :parent_id, :uid, :avatar, :linkedin, :twitter,
                                         :instagram, :online_portfolio, :id, :change_step)
  end

  def set_cookie
    cookies[:visit] = {
      value: Time.now,
      expires: 5.minute.from_now,
    }
  end
end
