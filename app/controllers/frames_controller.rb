class FramesController < ApplicationController

  layout "gallery"
  before_action :set_frame
  respond_to :js

  def download
    if params[:dont_show] == "true"
      session[:dont_show] = true
    end

    @gallery = @frame.gallery
    @project = @gallery.project

    digitals = @project.package.digitals

    limit_before_feed_back = (digitals / 2).to_i

    if limit_before_feed_back > 2
      limit_before_feed_back = 3
    end

    if @gallery.downloaded_count >= limit_before_feed_back and not @frame.downloaded

      unless @frame.gallery.project.feed_back.present?
        @show_feed_back_modal = true
        # respond_to do |format|
        #   format.js
        # end
      end

      if @gallery.project.reserve_step.name == "qualified" or @gallery.project.reserve_step.name == "downloaded"
        @show_exemption_modal = true
        # respond_to do |format|
        #   format.js
        # end
      end
    end


    if not @show_exemption_modal and not @show_feed_back_modal
      # update project reserve step
      if @gallery.project.reserve_step.name == "qualified" or @gallery.project.reserve_step.name == "re_edit" or @gallery.project.reserve_step.name == "uploaded"
        p = @gallery.project
        p.set_reserve_step("downloaded")
        p.send_customer = true
        p.is_uploaded = true
        p.save
      end
      #
      if @frame.downloaded
        @frame.downloaded_times = @frame.downloaded_times + 1
        @frame.save
        # @url = Cloudinary::Utils.cloudinary_url(@frame.public_id).to_s
        @url = @frame.file_address(false, "original")
        @gallery.project.user.create_activity :downloaded_original, owner: @gallery.project.user, recipient: @frame
      else
        #download all
        if @gallery.download_limit == 0
          @frame.downloaded_times = @frame.downloaded_times + 1
          if @frame.downloaded == false
            @frame.downloaded = true
            @gallery.downloaded_count = @gallery.downloaded_count + 1
          end
          @frame.save
          @gallery.save
          # @url = Cloudinary::Utils.cloudinary_url(@frame.public_id).to_s
          @url = @frame.file_address(false, "original")
          @gallery.project.user.create_activity :downloaded_original, owner: @gallery.project.user, recipient: @frame
          # download only a number of frames
        elsif @gallery.download_limit > 0
          if @gallery.downloaded_count < @gallery.download_limit #can choose more photos
            @frame.downloaded_times = @frame.downloaded_times + 1
            if @frame.downloaded == false
              @frame.downloaded = true
              @gallery.downloaded_count = @gallery.downloaded_count + 1
            end
            @new_downloaded_count = @gallery.downloaded_count
            @frame.save
            @gallery.save
            # @url = Cloudinary::Utils.cloudinary_url(@frame.public_id).to_s
            @url = @frame.file_address(false, "original")
            @gallery.project.user.create_activity :downloaded_original, owner: @gallery.project.user, recipient: @frame
          else # cant download more, should buy
            @error = "برای دانلود هر فریم بیشتر باید فریم انتخابی تان را خریداری کنید."
            @gallery.project.user.create_activity :couldnt_download, owner: @gallery.project.user, recipient: @frame
          end
        end
      end
    end

    # unless 2==2
    # if @error
    #   redirect_back(fallback_location: '/', alert: @error)
    # else
    #   send_file("#{Rails.root}/public#{@url}",
    #     :disposition => "attachment; filename=#{@frame.original_filename}", type: 'image/jpg')
    #   end
    # else
    # byebug
    respond_to do |format|
      format.js
    end
    # end
  end

  def expiring_link
    @url = Cloudinary::Utils.cloudinary_url(@frame.public_id).to_s
    cookies["'fileDownload"] = "true"
    data = open("#{@url}")
    send_data data.read,
    filename: "#{@frame.public_id}.jpeg",
    type: 'content-type',
    x_sendfile: true
  end

  def create
    @frame = Frame.new(frame_params)
    if @frame.save
      redirect_to edit_gallery_path(@frame.gallery.slug)
    end
  end

  def check_if_downloaded

    dont_show = false
    if session[:dont_show]
      dont_show = true
    end

    frame = Frame.find(params[:frame_id])
    downloaded = frame.downloaded
    gallery = frame.gallery
    should_buy = false
    unless gallery.download_limit == 0 or gallery.download_limit > gallery.downloaded_count
      should_buy = true
    end
    data = {downloaded: downloaded, should_buy: should_buy, dont_show: dont_show}
    render json: data
  end


  def get_id
    if params[:frame_name]
      frames = Frame.where('original_filename = ? or light_version_slug = ?', params[:frame_name], params[:frame_name])
      unless frames.size > 1
        frame = frames.first
        if frame.present?
          frame_id = frame.id
          render json: frame_id
        end
      end
    end
  end

  def like
    @frame = Frame.find(params[:id])
    if @frame.present?
      @like = params[:like] == "true" ? true : false
      @frame.like = @like
      @frame.save
    end
  end

  def destroy
    if @frame.gallery.project.photographer == current_photographer
      @frame.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def set_frame
    @frame = Frame.find_by(id: params[:id])
  end

  def frame_params
    params.require(:frame).permit(:file, :gallery_id)
  end

end

# downloadable to frames
# download times to frames
# if package update, update frame downloadable
#
