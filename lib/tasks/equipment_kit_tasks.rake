namespace :equipment_kit_tasks do
  desc "TODO"
  task clear_duplicate_record: :environment do
    Equipment.all.each do |equipment|
      kits_id = []
      remove_ids = []
      equipment.equipment_kits.each do |k|
        if kits_id.include?(k.kit.id)
          remove_ids << k.id
        else
          kits_id << k.kit.id
        end
      end
      remove_ids.each do |id|
        EquipmentKit.find(id).destroy
      end
    end
    EquipmentKit.all.each do |e|
      if !e.equipment.present?
        e.destroy
      end
    end
  end
end
