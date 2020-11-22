module Photographers
  class JoinLookups
    include Interactor

    def call
      context.kits = Kit.all
      context.cameras = Camera.all
      context.lenzs = Lenz.all
      context.shoot_types = ShootType.all
    end
  end
end