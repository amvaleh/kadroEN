class Address < ApplicationRecord
  has_many :projects
  has_many :invoices
  has_many :shoot_locations
  belongs_to :city

  # before_save :get_city_name

  require "json"
  require "net/http"

  def reverse_geo
    self.lattitude = self.lattitude.to_f
    self.longtitude = self.longtitude.to_f
  end

  def display_name
    input
  end

  def add_full() ()
    result = Net::HTTP.get(URI.parse(URI.encode("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{self.lattitude},#{self.longtitude}&key=AIzaSyBqAlo6eTQeSbkOn3xYIjJ4e1zr4ewrSxU&language=fa&region=IR")))
    result1 = JSON.parse(result)
    result2 = result1.first.second.second.to_a.second.second
    return result2   end

  def get_city_name
    if self.longtitude_changed? || self.lattitude_changed?
      result = GoogleApis::GetAreaAndCityName.call(lat: self.lattitude, long: self.longtitude)
      city = City.find_by_name(result.city)
      if !city.present?
        city = City.create(name: result.city)
      end
      if self.city != city
        self.city = city
      end
    end
  end

  scope :geoable, -> {
          where("longtitude is not null and lattitude is not null")
        }
end
