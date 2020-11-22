class VideographyController < ApplicationController
  layout 'wordpress'
  before_action :find_video_sample, except: [:index]


  def show
    @video
  end

  def index
    @videos = VideoSample.all
  end


  def find_video_sample
    @video = VideoSample.find_by(eng_title: params[:id])
  end


end
