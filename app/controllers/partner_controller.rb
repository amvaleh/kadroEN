class PartnerController < ApplicationController

  before_action :find_partner

  def show
    @partner.click_counter = @partner.click_counter + 1
    @partner.save
    redirect_to @partner.website
  end


  def find_partner
    @partner = Partner.find_by(:website=>params[:id])
  end

end
