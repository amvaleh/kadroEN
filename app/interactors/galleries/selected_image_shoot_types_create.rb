module Galleries
  class SelectedImageShootTypesCreate
    include Interactor

    def call
      selected = context.shoot_types.select {|_, v| v == '1'}
      selected_keys = selected.map {|k, _| k}
      if selected_keys.length > 0
        selectable_image = SelectableImage.find_by(image_type: context.image, image_id: context.image_id)
        if selectable_image.nil?
          selectable_image =
              if context.image == 'Frame'
                model_create(Frame, context.image_id, context.description)
              elsif context.image == 'Photo'
                model_create(Photo, context.image_id, context.description)
              end
        end

        SelectableImageShootType.where(selectable_image_id: selectable_image.id).delete_all
        selected_keys.each do |sk|
          SelectableImageShootType.create(selectable_image_id: selectable_image.id, shoot_type_id: sk)
        end
      else
        selectable_image_id = SelectableImage.where(image_type: context.image, image_id: context.image_id).pluck(:id)
        SelectableImageShootType.where(selectable_image_id: selectable_image_id).delete_all
        SelectableImage.where(image_type: context.image, image_id: context.image_id).delete_all
      end
    end

    private

    def model_create(model_name, image_id, description)
      SelectableImage.create(image: model_name.find(image_id), description: description)
    end
  end
end