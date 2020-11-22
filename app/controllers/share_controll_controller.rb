class ShareControllController < ApplicationController
  layout "photographer"
  respond_to :js
  before_action :find_frame

  def create
    @exceed_limit = false
    if @frame
      if @frame.gallery.frames.share_requested.count < Setting.find_by_var("max_share_request").value.to_i
        share_control = ShareControl.create(permit: false)
        @frame.share_control = share_control
        @frame.save
      else
        @exceed_limit = true
      end
    end
  end


  def allow
    share_control = @frame.share_control
    share_control.permit=true
    share_control.save
  end

  def disallow
    share_control = @frame.share_control
    share_control.permit=false
    share_control.save
  end


  private

  def find_frame
    @frame = Frame.find(params[:frame_id])
  end

end
