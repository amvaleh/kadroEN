module SelectableImages
  class SelectShootTypes
    include Interactor

    def call
      if context.image_type == "Frame"
        shoot_types = Frame.joins(selectable_images: :selectable_image_shoot_types).
        where('image_id=? AND selectable_images.image_type =? ', context.image_id, context.image_type).
        select('selectable_image_shoot_types.*').map {|a| a.shoot_type_id}
      elsif context.image_type == "Photo"
        shoot_types = Photo.joins(selectable_images: :selectable_image_shoot_types).
        where('image_id=? AND selectable_images.image_type =? ', context.image_id, context.image_type).
        select('selectable_image_shoot_types.*').map {|a| a.shoot_type_id}
      end
      context.shoot_types = shoot_types
    end
  end
end
