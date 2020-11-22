class ShootLocationAttachmentsController < ApplicationController

  before_action :find_shoot_location, except: [:destroy]
  before_action :find_shoot_location_attachment, except: [:create]
  respond_to :json

  def create
    if !@shoot_location.present?
      @shoot_location = ShootLocation.new(photographer_id: params[:photographer_id], approved: params[:approved], is_studio: params[:is_studio], title: params[:title])
      @shoot_location.save
    end
    @shoot_location_attachment = ShootLocationAttachment.create(photo: params[:file], shoot_location_id: @shoot_location.id)
    if @shoot_location_attachment.save
      head 200
    else
      @errors = @shoot_location_attachment.errors.messages[:size][0]
      head 406
    end
  end

  def destroy
    @shoot_location_attachment.destroy
    respond_to do |format|
      format.html { redirect_to studio_locations_url }
      format.json { head :no_content }
    end
  end

  private

  def find_shoot_location
    if params[:shoot_location_id].present?
      @shoot_location = ShootLocation.find_by(id: params[:shoot_location_id])
    else
      @shoot_location = ShootLocation.find_by(photographer_id: params[:photographer_id], approved: params[:approved], is_studio: params[:is_studio], title: params[:title])
    end
  end

  def find_shoot_location_attachment
    @shoot_location_attachment = ShootLocationAttachment.find_by(id: params[:id])
  end
end
