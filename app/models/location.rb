class Location < ApplicationRecord
  has_one :photographer
  has_settings :dashboard
  belongs_to :city

  # after_update :photographer_update

  after_create :get_area_name , :get_city_name
  after_save :update_area_name , :update_city_name

  geocoded_by :working_input         # can also be an IP address
  # after_validation :geocode          # auto-fetch coordinates

  reverse_geocoded_by :working_lat, :working_long , :address => :working_input
  after_validation :reverse_geocode

  require 'json'
  require 'net/http'

  def photographer_update
    self.photographer.update(:updated_at => Time.now)
  end

  def get_area_name
    if self.working_long_changed? || self.working_lat_changed?
      results = Net::HTTP.get(URI.parse(URI.encode("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{self.working_lat},#{self.working_long}&result_type=neighborhood&key=AIzaSyBqAlo6eTQeSbkOn3xYIjJ4e1zr4ewrSxU&language=fa&region=IR")))
      results1 = JSON.parse(results)
      results2 = results1['results']
      areas = []
      if results2.any?
        results3 = results2.first
        results4 = results3['address_components']
        # @n = 0
        results4.each do |result|
          result.to_a.each do |result1|
            if result1.first == "types"
              if result1.second.first == "neighborhood"
                areas << result.to_a.first.second
              end
            end
          end
        end
      end
      if areas.any?
        self.update_attributes(:area_name => areas.first)
      else
        self.update_attributes(:area_name => "غیره")
      end
    end
  end

  def get_city_name
    if self.working_long_changed? || self.working_lat_changed?
      results = Net::HTTP.get(URI.parse(URI.encode("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{self.working_lat},#{self.working_long}&result_type=locality&key=AIzaSyBqAlo6eTQeSbkOn3xYIjJ4e1zr4ewrSxU&language=fa&region=IR")))
      results1 = JSON.parse(results)
      results2 = results1['results']
      areas = []
      if results2.any?
        results3 = results2.first
        results4 = results3['address_components']
        # @n = 0
        results4.each do |result|
          result.to_a.each do |result1|
            if result1.first == "types"
              if result1.second.first == "locality"
                areas << result.to_a.first.second
              end
            end
          end
        end
      end
      if areas.any?
        self.update_attributes(:city_name => areas.first)
      else
        self.update_attributes(:city_name => "غیره")
      end
      city = City.find_by_name(self.city_name)
      if !city.present?
        city = City.find_by_eng_name(loc.city_name)
      end
      if city.present?
        self.city = city
        self.save
      else
        new_city = City.create(:name => self.city_name, :latitude => self.working_lat, :longitude => self.working_long)
        self.city = new_city
        self.save
      end
    end
  end

  def update_area_name
    if self.working_long_changed? || self.working_lat_changed?
      results = Net::HTTP.get(URI.parse(URI.encode("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{self.working_lat},#{self.working_long}&result_type=neighborhood&key=AIzaSyBqAlo6eTQeSbkOn3xYIjJ4e1zr4ewrSxU&language=fa&region=IR")))
      results1 = JSON.parse(results)
      results2 = results1['results']
      areas = []
      if results2.any?
        results3 = results2.first
        results4 = results3['address_components']
        # @n = 0
        results4.each do |result|
          result.to_a.each do |result1|
            if result1.first == "types"
              if result1.second.first == "neighborhood"
                areas << result.to_a.first.second
              end
            end
          end
        end
      end
      if areas.any?
        Location.where(id: self.id).update_all(:area_name => areas.first)
      else
        Location.where(id: self.id).update_all(:area_name => "غیره")
      end
    end
  end

  def update_city_name
    if self.working_long_changed? || self.working_lat_changed?
      results = Net::HTTP.get(URI.parse(URI.encode("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{self.working_lat},#{self.working_long}&result_type=locality&key=AIzaSyBqAlo6eTQeSbkOn3xYIjJ4e1zr4ewrSxU&language=fa&region=IR")))
      results1 = JSON.parse(results)
      results2 = results1['results']
      areas = []
      if results2.any?
        results3 = results2.first
        results4 = results3['address_components']
        # @n = 0
        results4.each do |result|
          result.to_a.each do |result1|
            if result1.first == "types"
              if result1.second.first == "locality"
                areas << result.to_a.first.second
              end
            end
          end
        end
      end
      if areas.any?
        Location.where(id: self.id).update_all(:city_name => areas.first)
        area = areas.first
      else
        Location.where(id: self.id).update_all(:city_name => "غیره")
      end
      if area.present?
        city = City.find_by_name(area)
        if !city.present?
          city = City.find_by_eng_name(area)
        end
        if city.present?
          Location.where(id: self.id).update_all(:city_id => city.id)
        else
          new_city = City.create(:name => area, :latitude => self.working_lat, :longitude => self.working_long)
          Location.where(id: self.id).update_all(:city_id => new_city.id)
        end
      else
        other_city = City.find_by_eng_name("Other")
        Location.where(id: self.id).update_all(:city_id => other_city.id)
      end
    end
  end


  def add_area()
    results = Net::HTTP.get(URI.parse(URI.encode("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{self.working_lat},#{self.working_long}&key=AIzaSyBqAlo6eTQeSbkOn3xYIjJ4e1zr4ewrSxU&language=fa&region=IR")))
    results1 = JSON.parse(results)
    results2 = results1['results']
    areas = []
    if results2.any?
      results3 = results2.first
      results4 = results3['address_components']
      # @n = 0
      results4.each do |result|
        result.to_a.each do |result1|
          if result1.first == "types"
            if result1.second.first == "neighborhood"
              areas << result.to_a.first.second
            end
          end
        end
      end
    end
    if areas.any?
      return areas.first
    else
      return "تهران"
    end

    # if @n > 1
    #   final = []
    #   (1..@n).each do |i|
    #     if areas[i] = areas[i+1]
    #       final << areas[i]
    #     end
    #   end
    #   return final
    # else
    #   return areas
    # end

  end
end
