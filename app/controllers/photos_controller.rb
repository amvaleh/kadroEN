class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  layout "wordpress" , only: [:photo_content]

  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.all
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

#
# Photographer.joins(:join_step).where(join_steps: {name: 'در انتظار مصاحبه'}).joins(:location).where(locations: {city_name: cities}).order(last_step_at: :desc)

  def photo_content
    if params[:shoot_type].present?
      @photos = Photo.joins(:expertise => :photographer).where('shoot_type_id = ? and photographers.approved = ? and expertises.approved = ?', params[:shoot_type],true,true)
    else
      @photos= Photo.joins(:expertise => :photographer).where('photographers.approved = ? and expertises.approved = ?',true,true)
    end
  end

  def types
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(photo_params)
    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    # deleting the expertise if this is the last photo
    if @photo.expertise.photos.count == 1
      @photo.expertise.destroy
    end
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.fetch(:photo, {})
    end
end
