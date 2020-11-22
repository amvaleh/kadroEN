class Api::V2::LocationsController < ApiController
  skip_before_action :authenticate_token
  respond_to :json

  def active_cities
    cities = ActiveCity.all
    render json: {cities: cities}, result: "True", status: :accepted
  end
end
