class GiftsController < ApplicationController
  layout "gifts"

  before_action :verify_authenticity_token , only: [:happy_photographers_day]

  def happy_photographers_day

  end



end
