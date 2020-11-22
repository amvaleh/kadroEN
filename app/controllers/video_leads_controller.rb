class VideoLeadsController < ApplicationController
  layout "wordpress"
  respond_to :js

  def new
  end

  def create
    @video_lead = VideoLead.new(name: params[:name], phone_number: params[:phone_number], budget: params[:budget], email: params[:email], detail: params[:detail])
    respond_to do |format|
      if @video_lead.save
        format.js
      end
    end
  end
end
