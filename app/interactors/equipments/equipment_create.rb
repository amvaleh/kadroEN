module Equipments
  class EquipmentCreate
    include Interactor

    def call
      ActiveRecord::Base.transaction do
        equipment = Equipment.find_by(photographer_id: context.data[:photographer_id])

        photographer = Photographer.find(context.data[:photographer_id])
        if equipment.nil?
          equipment = Equipment.new
          create_action = true
        else
          photographer.create_activity :ph_edit_equipments, owner: photographer, recipient: equipment
        end


        equipkits = EquipmentKit.where(equipment_id: equipment.id)

        if equipkits.any?
          equipkits.delete_all
        end

        equipment.small_product_kit = false
        equipment.large_product_kit = false
        equipment.portable_light = false
        equipment.light_studio_kit = false
        equipment.portable_studio_kit = false
        dont_have = Kit.find_by(title: "dont_have")
        dont_have_not_present = true
        if context.data[:kit_id].present?
          context.data[:kit_id].each do |kit_id|
            if kit_id == dont_have.id
              dont_have_not_present = false
            end
          end
          if dont_have_not_present
            context.data[:kit_id].each do |kit_id|
              # kit = Kit.joins(:equipments).where('photographer_id = ? and kits.id = ?', context.data[:photographer_id], kit_id).take(1)[0]
              kit = Kit.find(kit_id)
              equipment.kits << kit
              case kit.title
              when "small_product_kit"
                equipment.small_product_kit = true
              when "large_product_kit"
                equipment.large_product_kit = true
              when "portable_light"
                equipment.portable_light = true
              when "dual_light_studio_kit"
                equipment.light_studio_kit = true
              when "portable_studio_kit"
                equipment.portable_studio_kit = true
              end
            end
          end
        end
        equip_cameras = EquipCamera.where(equipment_id: equipment.id)
        if equip_cameras.any?
          equip_cameras.delete_all
        end

        if context.data[:camera_id].present?
          context.data[:camera_id].each do |camera_id|
            camera = Camera.find(camera_id)
            equipment.cameras << camera
          end
        end
        equip_lenzes = EquipLenz.where(equipment_id: equipment.id)
        if equip_lenzes.any?
          equip_lenzes.delete_all
        end
        if context.data[:lenz_id].present?
          context.data[:lenz_id].each do |lenz_id|
            lenz = Lenz.find(lenz_id)
            equipment.lenzs << lenz
          end
        end

        equipment.save

        photographer.equipment = equipment
        if photographer.join_step.code <= JoinStep.find_by_name("اطلاعات مکانی").code
          photographer.join_step_id = JoinStep.find_by_name("تجهیزات عکاسی").id
        end
        photographer.save
        if equipment.save
          if create_action.present?
            photographer.create_activity :ph_join_equipments, owner: photographer, recipient: equipment
          end
          context.equipment = equipment
        else
          context.errors = equipment.errors.messages
          # raise ActiveRecord::Rollback
          context.fail!
        end
      end
    end
  end
end
