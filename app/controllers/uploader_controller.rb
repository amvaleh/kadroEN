class UploaderController < ApplicationController

  layout 'kadro'

  def new
    if params[:image].present?
      @gallery = Gallery.friendly.find(params[:id])
      params[:image].each do |image|
        preloaded = Cloudinary::PreloadedFile.new(image)
        raise "Invalid upload signature" if !preloaded.valid?
        filename = @gallery.project.user.display_name
        filename = filename + "-" + (@gallery.frames.count+1).to_s
        frame = Frame.new(:gallery_id=>@gallery.id, :public_id=>preloaded.public_id,:signature=>preloaded.signature,:file_name=> filename.to_s ,:resource_type=>preloaded.resource_type)
        frame.save
      end
      respond_to do |format|
        format.html { redirect_to edit_gallery_path(params[:id],params[:id]) }
        format.json { render json: {result: "saved!" , status: :ok} }
      end
    else
      respond_to do |format|
        format.html { redirect_to edit_gallery_path(params[:id],params[:id]) , alert: "خطا در شناسه عکس" }
        format.json {  render json: {result: "Error before save!" , status: :unprocessable_entity} }
      end
    end
  end


  def uploadframe
    @frame = Frame.new(file: params[:file])
    redirect_to :back , notice: 'Frame uploaded' if @frame.save
  end

  private



end
