namespace :location_tasks do
  desc "TODO"
  task get_area_name: :environment do
    @photographers = Photographer.all
    @photographers.each do |photographer|
      if photographer.location.present?
        location = photographer.location
        if location.working_lat.present? && location.working_long.present?
          puts "updating..."
          puts photographer.id.to_s
          results = Net::HTTP.get(URI.parse(URI.encode("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{location.working_lat},#{location.working_long}&key=AIzaSyBqAlo6eTQeSbkOn3xYIjJ4e1zr4ewrSxU&language=fa&region=IR")))
          results1 = JSON.parse(results)
          results2 = results1.first.second
          areas = []
          results2.each do |result|
            result.to_a.first.second.each do |result1|
              if result1.to_a.third.second.first == "neighborhood"
                areas << result1.to_a.first.second
                # @n = @n + 1
              end
            end
          end
          if areas.any?
            location.area_name = areas.first
            location.save
          else
            results = Net::HTTP.get(URI.parse(URI.encode("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{location.working_lat},#{location.working_long}&key=AIzaSyBqAlo6eTQeSbkOn3xYIjJ4e1zr4ewrSxU&language=fa&region=IR")))
            results1 = JSON.parse(results)
            results2 = results1.first.second
            results2.each do |result|
              result.to_a.first.second.each do |result1|
                if result1.to_a.third.second.first == "neighborhood"
                  areas << result1.to_a.first.second
                  # @n = @n + 1
                end
              end
            end
            if areas.any?
              location.area_name = areas.first
              location.save
            else
              location.area_name = "غیره"
              location.save
            end
          end
        end
      end
    end
  end

  desc "TODO"
  task :city_name => :environment do
    @photographers = Photographer.all
    @photographers.each do |photographer|
      if photographer.location.present?
        location = photographer.location
        if location.working_lat.present? && location.working_long.present?
          results = Net::HTTP.get(URI.parse(URI.encode("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{location.working_lat},#{location.working_long}&result_type=locality&key=AIzaSyBqAlo6eTQeSbkOn3xYIjJ4e1zr4ewrSxU&language=fa&region=IR")))
          results1 = JSON.parse(results)
          results2 = results1.first.second
          areas = []
          results2.each do |result|
            result.to_a.first.second.each do |result1|
              if result1.to_a.third.second.first == "locality"
                areas << result1.to_a.first.second
                # @n = @n + 1
              end
            end
          end
          if areas.any?
            location.city_name = areas.first
            location.save
          else

            results = Net::HTTP.get(URI.parse(URI.encode("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{location.working_lat},#{location.working_long}&key=AIzaSyBqAlo6eTQeSbkOn3xYIjJ4e1zr4ewrSxU&language=fa&region=IR")))
            results1 = JSON.parse(results)
            results2 = results1.first.second
            results2.each do |result|
              result.to_a.first.second.each do |result1|
                if result1.to_a.third.second.first == "locality"
                  areas << result1.to_a.first.second
                  # @n = @n + 1
                end
              end
            end
            if areas.any?
              location.city_name = areas.first
              location.save
            else
              location.city_name = "غیره"
              location.save
            end
          end
        end
      end
    end
  end

  desc "TODO"
  task :city_id => :environment do
    Location.all.each do |loc|
	puts loc.id
      if loc.city_name.present?
        city = City.find_by_name(loc.city_name)
        if !city.present?
          city = City.find_by_eng_name(loc.city_name)
        end
        if city.present?
          loc.city = city
          loc.save
        else
          new_city = City.create(:name => loc.city_name)
          loc.city = new_city
          loc.save
        end
      else
        loc.city = City.find_by_eng_name("Other")
        loc.save
      end

      # if loc.working_lat.present? && loc.working_long.present?
      #   lat = loc.working_lat
      #   lon = loc.working_long
      #   lat_lon = "#{lat},#{lon}"
      #   response = Geocoder.search(lat_lon).first
      #   city_name = response.city
      #   city = City.find_by_name(city_name)
      #   if city.present?
      #     loc.city = city
      #     loc.save
      #   else
      #     new_city = City.create(:name => city_name)
      #     loc.city = new_city
      #     loc.save
      #   end
      # else
      #   loc.city_id = City.find_by_eng_name("Other")
      #   loc.save
      # end

    end
  end
end
