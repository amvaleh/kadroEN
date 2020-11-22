namespace :selectable_image_tasks do
  desc "TODO"
  task remove_not_exist: :environment do
    SelectableImage.all.each do |se|
      if se.image_type == "Photo"
        p = Photo.where(id: se.image_id)
      elsif se.image_type == "Frame"
        p = Frame.where(id: se.image_id)
      end
      if !p.any?
        SelectableImageShootType.where(selectable_image_id: se.id).destroy_all
        se.destroy
      end
    end
  end

  desc "publish false selectebale images when photographer is not approved"
  task publish_false_for_unapproved_ph: :environment do
    SelectableImage.published.each do |se|
      if se.image_type == "Photo"
        p = Photo.find_by(id: se.image_id)
        if p.present? && p.expertise.present?
          if p.expertise.photographer.approved == false
            puts p.id
            se.published = false
            se.save
          end
        else
          puts "p.id"
          se.published = false
          se.save
        end
      end
    end
  end
end
