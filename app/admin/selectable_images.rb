ActiveAdmin.register SelectableImage do
  permit_params :description, :image_type, :published

  filter :published
  filter :image_type
  filter :image_id
  filter :description
  filter :like_number
  filter :dislike_number
  filter :created_at
  filter :shoot_type

  menu parent: "General Settings", priority: 15
  index :title => "عکس های منتخب" do
    column :id
    column :image_type
    column "Photographer" do |s|
      if s.image_type == "Frame"
        if Frame.find_by_id(s.image_id).present?
          fr = Frame.find(s.image_id)
          link_to admin_photographer_url(fr.gallery.project.photographer.mobile_number), :target => "_blank" do
            fr.gallery.project.photographer.display_name
          end
        end
      elsif s.image_type == "Photo"
        if Photo.find_by_id(s.image_id).present?
          ph = Photo.find(s.image_id)
          link_to admin_photographer_url(ph.expertise.photographer.mobile_number), :target => "_blank" do
            ph.expertise.photographer.display_name
          end
        end
      end
    end
    column "image link" do |s|
      if s.image_type == "Frame"
        if Frame.find_by_id(s.image_id).present?
          fr = Frame.find(s.image_id)
          link_to fr.file_url, :target => "_blank" do
            image_tag fr.file_url(:light), :width => 100
          end
        end
      elsif s.image_type == "Photo"
        if Photo.find_by_id(s.image_id).present?
          ph = Photo.find(s.image_id)
          link_to ph.file_url(:medium), :target => "_blank" do
            image_tag ph.file_url(:medium), :width => 100
          end
        end
      end
    end
    column :like_number
    column :dislike_number
    toggle_bool_column :published
    actions
  end
  #   panel 'جستجو' do
  #     render partial: 'search_form'
  #   end
  #
  #   selectable_images = SelectableImage.joins("left join frames f on f.id = selectable_images.image_id and image_type = 'Frame'").
  #   joins("left join photos p on p.id = selectable_images.image_id and image_type = 'Photo'").
  #   select('f.id frame_id, p.id photo_id, selectable_images.*')
  #   if params[:selectable_image_search] && params[:selectable_image_search][:shoot_types] != ['']
  #     selectable_images = selectable_images.where('selectable_images.id in (
  #       select selectable_image_id from selectable_image_shoot_types
  #       where shoot_type_id in (?)
  #       )', params[:selectable_image_search][:shoot_types].map(&:to_i))
  #     end
  #     frame_ids = selectable_images.select {|si| si.image_type == 'Frame'}.map(&:image_id)
  #     photo_ids = selectable_images.select {|si| si.image_type == 'Photo'}.map(&:image_id)
  #     frames = Frame.where('frames.id in (?)', frame_ids).load
  #     frame_shoot_types = Frame.joins(selectable_images: :selectable_image_shoot_types).
  #     joins('inner join shoot_types st on st.id = selectable_image_shoot_types.shoot_type_id').
  #     select('st.title shoot_type_title, frames.*').
  #     where('frames.id in (?)', frame_ids).load
  #
  #     photos = Photo.where('id in (?)', photo_ids).load
  #     photo_shoot_types = Photo.joins(selectable_images: :selectable_image_shoot_types).
  #     joins('inner join shoot_types st on st.id = selectable_image_shoot_types.shoot_type_id').
  #     select('st.title shoot_type_title, photos.*').
  #     where('photos.id in (?)', photo_ids).load
  #     render partial: 'list', locals: {selectable_images: selectable_images, frames: frames, photos: photos, frame_shoot_types: frame_shoot_types, photo_shoot_types: photo_shoot_types}
  #   end

  collection_action :search_image, method: :post do
    redirect_to controller: "selectable_images", action: "index", selectable_image_search: params[:selectable_image_search]
  end

  show do
    div span: 2 do
      attributes_table do
        row :description
        row :like_number
        row :dislike_number
        row :published
      end
    end
  end

  form do |f|
    f.inputs "ویرایش", style: "direction: rtl; margin-right: 20px" do
      div span: 5, style: "color: dodgerblue; font-size: 24px; direction: ltr" do
        "کامنت:"
      end
      f.text_area :description
      f.input :like_number
      f.input :dislike_number
      f.input :published
    end
    f.actions
  end
end
