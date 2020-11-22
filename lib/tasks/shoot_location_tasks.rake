namespace :shoot_location_tasks do
  desc "TODO"
  task create_slug: :environment do
    shoot_locations = ShootLocation.where(slug: nil)
    shoot_locations.each do |sh|
      sh.save
      puts sh.slug
    end
  end

  desc "set studio shoot_type_locations for photographer with expertises"
  task set_studio_shoot_type_locations: :environment do
    shoot_locations = ShootLocation.where(is_studio: true)
    shoot_locations.each do |sh|
      if sh.photographer.present?
        sh.photographer.expertises.each do |e|
          if e.approved?
            r = true
            sh.shoot_type_locations.each do |shl|
              if shl.shoot_type == e.shoot_type
                r = false
              end
            end
            if r
              shoot_type_location = ShootTypeLocation.new(shoot_type_id: e.shoot_type_id, shoot_location_id: sh.id)
              shoot_type_location.save
            end
          end
        end
      end
    end
  end

end
