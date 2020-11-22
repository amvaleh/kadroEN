class ScannedProfilesController < ApplicationController

  layout "photographer"

  before_action :find_photographer
  before_action :find_scanned_profile, except: [:has_scanned_profile]
  before_action :authenticate_photographer!

  def has_scanned_profile
    # render locals: {photographer: photographer}
    if @photographer.scanned_profile.present?
      redirect_to scanned_profile_path(@photographer.scanned_profile.id)
    else
      scanned_profile = ScannedProfile.create(photographer_id: @photographer.id)
      redirect_to scanned_profile_path(scanned_profile.id)
    end
  end

  def show
    Rw::Authorize.call(@photographer, ScannedProfilePolicy, :scanned_profile_show?, @scanned_profile)
  rescue Exception => e
    redirect_to studio_photographer_path(@photographer), alert: e.message
  end

  def create
    if params[:scanned_profile]
      result = ScannedProfiles::ScannedProfileUpdate.call(data: params[:scanned_profile], scanned_profile: @scanned_profile)
      if result.success?
        @photographer.create_activity :ph_update_scanned_profile, owner: @photographer, recipient: result.scanned_profile
        flash[:notice] = 'مدرک با موفقیت آپلود شد.'
        redirect_to scanned_profile_path(@photographer), alert: I18n.t(:'photographers.messages.success_message')
      else
        flash[:notice] = 'آپلود نا موفق بود.'
        redirect_to scanned_profile_path(@photographer)
      end
    else
      flash[:notice] = 'تغییری در مدارک شناسایی ایجاد نشد.'
      redirect_to scanned_profile_path(@photographer)
    end
  end

  private


  def find_photographer
    @photographer = current_photographer
  end

  def find_scanned_profile
    @scanned_profile = current_photographer.scanned_profile
  end


end
