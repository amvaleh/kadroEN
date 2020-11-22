class FeedBacksController < ApplicationController

  layout :resolve_layout
  devise_group :watcher, contains: [:user, :admin]
  before_action :set_gallery_project
  before_action :authenticate_user!


  def dashboard_show
    @remote = false
    if @project.reserve_step_id == 14 or @project.reserve_step_id == 15
      @remote = true
    end
  end

  def show
    @remote = false
    if @project.reserve_step_id == 14 or @project.reserve_step_id == 15
      @remote = true
    end
  end

  def create
    feed_back = @project.feed_back
    if feed_back.present?
      if params[:is_remote] == "true"
        respond_to do |format|
          format.js
        end
      else
        if @project.has_gallery?
          redirect_to gallery_path(@gallery), alert: "قبلا برای این پروژه امتیاز ثبت شده است."
        else
          redirect_to feed_backs_path(@project.slug), alert: "قبلا برای این پروژه امتیاز ثبت شده است."
        end
      end
    else
      feed_back = FeedBack.new(feed_backs_params)
      feed_back.project = @project
      feed_back.save
      @gallery
      if params[:is_remote] == "true"
        respond_to do |format|
          format.js
        end
      else
        if @project.has_gallery?
          redirect_to gallery_path(@gallery), notice: "امتیاز دهی با موفقیت ثبت شد."
        else
          redirect_to feed_backs_path(@project.slug), notice: "نظرات شما با موفقیت ثبت شد."
        end
      end
    end
  end

  private

  def set_gallery_project
    @project = Project.find_by_slug(params[:id])
    @gallery = @project.gallery
    @user = @project.user
  end

  def resolve_layout
    case action_name
    when "show"
      "gallery"
    when "index"
      "gallery"
    when "dashboard_show"
      "dashboard"
    else
      "photographer"
    end
  end

  def feed_backs_params
    params.require(:feed_back).permit(:qrate, :arate, :description,:used_mask)
  end

end
