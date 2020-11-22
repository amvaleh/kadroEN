class FreeTimesController < ApplicationController
  before_action :find_photographer

  def close_all
    @photographer.free_times.destroy_all
    redirect_to times_photographer_path(@photographer) , alert:"زمان های خالی تقویم شما با موفقیت حذف گردید."
  end

  def open_most
    @photographer.free_times.destroy_all
    result = FreeTimes::CreateMostFreeTime.call(photographer: @photographer)
    if result.success
      redirect_to times_photographer_path(@photographer) , notice:"زمان های تقویم شما در بیشترین حالت قرار گرفت."
    else
      redirect_to times_photographer_path(@photographer) , alert:"خطا در به روز رسانی اطلاعات تقویم شما"
    end
  end

  def open_optimum
    result = FreeTimes::CreateOptimumFreeTime.call(photographer: @photographer)
    @projects = result.projects
    redirect_to times_photographer_path(@photographer) , notice:" زمان های تقویم شما در بهینه ترین حالت قرار گرفت."
  end

  def find_photographer
    @photographer = Photographer.friendly.find(params[:id])
  end

end
