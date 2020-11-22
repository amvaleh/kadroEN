class MapsController < ApplicationController
  respond_to :js
  def photographer_filter
    if params[:maps].present?
      result = Maps::PhotographerFilter.call(data: params['maps'])
      @approved_photographer = []
      @not_approved_photographer = []
      result.photographers.each do |ph|
        if ph.approved
          @approved_photographer << ph
        else
          @not_approved_photographer << ph
        end
      end
    end
  end

  def photographer_filter_with_distance
    if params[:maps].present?
      if params[:maps][:distance].present?
        @distance = params[:maps][:distance]
      end
      result = Maps::PhotographerFilter.call(data: params['maps'])
      @approved_photographer = []
      result.photographers.each do |ph|
        if ph.approved
          @approved_photographer << ph
        end
      end
    end
  end

end
