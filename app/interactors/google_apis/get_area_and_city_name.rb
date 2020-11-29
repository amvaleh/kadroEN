module GoogleApis
  class GetAreaAndCityName
    include Interactor

    def call
      results = Net::HTTP.get(URI.parse(URI.encode("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{context.lat},#{context.long}&result_type=neighborhood&key=AIzaSyBqAlo6eTQeSbkOn3xYIjJ4e1zr4ewrSxU&language=en&region=IR")))
      results1 = JSON.parse(results)
      results2 = results1["results"]
      area = []
      city = []
      if results2.any?
        results3 = results2.first
        results4 = results3["address_components"]
        results4.each do |result|
          result.to_a.each do |result1|
            if result1.first == "types"
              if result1.second.first == "neighborhood"
                area << result.to_a.first.second
              end
              if result1.second.first == "locality"
                city << result.to_a.first.second
              end
            end
          end
        end
      end
      if area.any? && city.any?
        context.city_name = city.first
        context.area_name = area.first
      elsif area.any?
        context.area_name = area.first
        context.city_name = "غیره"
      elsif city.any?
        context.city_name = city.first
        context.area_name = "غیره"
      else
        context.city_name = "غیره"
        context.area_name = "غیره"
      end
    end
  end
end
