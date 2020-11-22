module Photographers
  class PhotographerStepInfo
    include Interactor

    def call
      context.photographer = Photographer.find_by(id: context.photographer_id)
      context.location = context.photographer.location

      equipment = Equipment.where(photographer_id: context.photographer_id).take(1)[0]
      context.lenzs = equipment ? equipment.lenzs : nil
      context.cameras = equipment ? equipment.cameras : nil
      context.kits = equipment ? equipment.kits : nil
      context.equipment = equipment
      context.experience = context.photographer.experience
      context.photographer_expertises = Expertise.where(photographer_id: context.photographer_id)
    end
  end
end