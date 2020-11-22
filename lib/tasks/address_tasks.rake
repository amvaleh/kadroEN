namespace :address_tasks do
  desc "TODO"
  task get_city_for_shoot_locations: :environment do
    shoot_locations = ShootLocation.all
    shoot_locations.each do |sh|
      address = sh.address
      if !address.city.present?
        result = NeshanApis::GetAreaAndCityName.call(lat: address.lattitude, long: address.longtitude)
        city = City.find_by_name(result.city)
        puts "#{result.city} -----"
        if !city.present? && result.city != nil
          city = City.create(name: result.city)
        end
        if address.city != city
          address.city = city
          address.save
        end
      end
    end
  end
  desc "TODO"
  task get_city_for_addresses: :environment do
    addresses = Address.where("addresses.city_id is null")
    addresses.each do |address|
      if !address.city.present?
        result = NeshanApis::GetAreaAndCityName.call(lat: address.lattitude, long: address.longtitude)
        city = City.find_by_name(result.city)
        puts "#{result.city} -----"
        if !city.present? && result.city != nil
          city = City.create(name: result.city)
        end
        if address.city != city
          address.city = city
          address.save
        end
      end
    end
  end
end
