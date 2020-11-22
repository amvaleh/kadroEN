module Admins
  class CheckAdminGender
    include Interactor

    def call
      gallery = Gallery.find_by(slug: context.slug)
      if not gallery.project.publishable and gallery.project.shoot_type.is_personal
        if context.admin.gender == 2
          context.access = false
        else
          context.access = true
        end
      else
        context.access = true
      end
    end
  end
end