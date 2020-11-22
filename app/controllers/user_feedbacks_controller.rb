class UserFeedbacksController < ApplicationController

  layout :resolve_layout
  devise_group :watcher, contains: [:photographer, :admin]
  before_action :set_gallery_project
  before_action :authenticate_photographer!

  def show
  end

  def create
    user_feedback = UserFeedback.find_by_project_id(@project)
    if user_feedback.present?
      redirect_to edit_gallery_path(@gallery) , alert: "قبلا برای این پروژه امتیاز ثبت شده است."
    else
      if params[:user_feedback_question].present?
      result = UserFeedbacks::UserFeedbackCreate.call(data: params , project: @project)
      @photographer.create_activity :ph_feedback_project, owner: @photographer, recipient: result.user_feedback if result.user_feedback.present?
      redirect_to projects_photographer_path(@photographer) , notice: "امتیاز دهی با موفقیت ثبت شد."
    else
      redirect_to projects_photographer_path(@photographer) , notice: "اطلاعاتی دریافت نشد."
    end
    end
  end

  private

  def set_gallery_project
    @project = Project.find_by_slug(params[:id])
    @gallery = @project.gallery
    @user = @project.user
    @photographer = current_photographer
  end

  def resolve_layout
    "photographer"
  end

end
