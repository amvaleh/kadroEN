module ShootTypes
  class ShootTypesLoad
    include Interactor

    def call
      shoot_types = ShootType.joins(:expertises).where('expertises.photographer_id = ?',context.photographer_id).order("expertises.order ASC")
      context.shoot_types = shoot_types
    end
  end
end