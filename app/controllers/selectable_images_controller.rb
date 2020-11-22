class SelectableImagesController < ApplicationController
  before_action :set_selectable_image, :check_session_permit, only: [:like]
  respond_to :json
  respond_to :js

  def create
    if params[:photo_id].present?
      @selectable = SelectableImage.find_by(image_id: params[:photo_id], image_type: "Photo")
      if !@selectable.present?
        @photo = Photo.find_by(id: params[:photo_id])
        if @photo.present?
          @status = params[:status]
          @selectable = SelectableImage.new(image_id: @photo.id, image_type: "Photo")
          @selectable.save
          selectable_shoot_type = ShootType.find_by(id: params[:shoot_type_id])
          if selectable_shoot_type.present?
            selectable_image_shoot_type = SelectableImageShootType.create(selectable_image_id: @selectable.id, shoot_type_id: selectable_shoot_type.id)
          end
          respond_to do |format|
            if @selectable.save
              format.js
            end
          end
        end
      end
    end
  end


  def single_photo
    @type = params[:type]
    @file_url = params[:file_url]
    @ph_name = params[:ph_name]
    if @type == "Photo"
      @file = Photo.find( params[:file].to_i )
    elsif @type == "Frame"
      @file = Frame.find( params[:file].to_i )
    end
    @f = SelectableImage.find(params[:f])
    @shoot_type = ShootType.find(params[:st])
  end



  def like
    if @permit
      if @selectable_image.present?
        @selectable_image = SelectableImages::IncreaseOfLikeOrDislike.call(selectable_image: @selectable_image, amount: 1 , status: params[:status]).selectable_image
        @selectable_image.save
        render json: @selectable_image, status: :ok
      end
    else
      render json:  @selectable_image , status: :ok
    end
  end

  private

  def set_selectable_image
    @selectable_image = SelectableImage.find_by(id: params[:id])
  end

  def check_session_permit
    last = session["sample_" + @selectable_image.id.to_s]
    if (!last.nil?)
      if params[:status] == "like"
        new = true
      elsif params[:status] == "dislike"
        new = false
      end
      if (new ^ last)
        @permit = true
        session["sample_" + @selectable_image.id.to_s] = !last
        @selectable_image = SelectableImages::ReduceOfLikeOrDislike.call(selectable_image: @selectable_image, amount: 1 , status: new).selectable_image
      else
        @permit = false
      end
    else
      if params[:cookie] == "like" && params[:status] == "dislike"
        @selectable_image = SelectableImages::ReduceOfLikeOrDislike.call(selectable_image: @selectable_image, amount: 1 , status: false).selectable_image
      elsif params[:cookie] == "dislike" && params[:status] == "like"
        @selectable_image = SelectableImages::ReduceOfLikeOrDislike.call(selectable_image: @selectable_image, amount: 1 , status: true).selectable_image
      end
      if params[:status] == "like"
        session["sample_" + @selectable_image.id.to_s] = true
        @permit = true
      elsif params[:status] == "dislike"
        session["sample_" + @selectable_image.id.to_s] = false
        @permit = true
      end
    end
  end

  def selectable_image_params
    params.require(:selectable_image).permit(:id, :image_id, :image_type)
  end

end
