namespace :equipment_kits_tasks do
  desc "Fill the Equipment Kits table with old record"
  task fill_equipment_kits: :environment do
    equipments = Equipment.all
    equipments.each do |equipment|
      if !equipment.equipment_kits.any?
        if equipment.small_product_kit
          equip_kit = EquipmentKit.new
          kit = Kit.find_by_title("small_product_kit")
          equip_kit.equipment = equipment
          equip_kit.kit = kit
          equip_kit.save
        end
        if equipment.large_product_kit
          equip_kit = EquipmentKit.new
          kit = Kit.find_by_title("large_product_kit")
          equip_kit.equipment = equipment
          equip_kit.kit = kit
          equip_kit.save
        end
        if equipment.portable_light
          equip_kit = EquipmentKit.new
          kit = Kit.find_by_title("portable_light")
          equip_kit.equipment = equipment
          equip_kit.kit = kit
          equip_kit.save
        end
        if equipment.light_studio_kit
          equip_kit = EquipmentKit.new
          kit = Kit.find_by_title("dual_light_studio_kit")
          equip_kit.equipment = equipment
          equip_kit.kit = kit
          equip_kit.save
        end
        if equipment.portable_studio_kit
          equip_kit = EquipmentKit.new
          kit = Kit.find_by_title("portable_studio_kit")
          equip_kit.equipment = equipment
          equip_kit.kit = kit
          equip_kit.save
        end
      end
    end
  end

end
