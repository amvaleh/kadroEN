ActiveAdmin.register ShareControl do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  config.batch_actions = false
  permit_params :title, :permit, :request_sent_to_user, :last_seen_user, :permission_sent_to_photographer
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  menu parent: "General Settings", priority: 16
  filter :title
  filter :permit
  filter :permission_sent_to_photographer
  filter :request_sent_to_user
  filter :last_seen_user
  filter :created_at
  filter :updated_at
  filter :shoot_type_select, as: :select, collection: ShootType.all.collect { |l| [l.title, l.id] }
  filter :photographer_select, as: :select, collection: Photographer.approved.collect { |l| [l.display_name, l.id] }

  show do
    render "shared/modal"
    div span: 2 do
      attributes_table do
        row :permit
        row :title
        row :request_sent_to_user
        row :permission_sent_to_photographer
        row :last_seen_user
        row "selectable images" do |f|
          if f.permit == true
            link_to("انتخاب تصویر", select_frame_form_admin_galleries_path(image_id: f.frame.id, image_type: "Frame"), class: "btn btn-success btn-large", remote: true)
          else
            "محافظت شده"
          end
        end
        row :created_at
        row :updated_at
      end
    end
  end

  index :title => "کنترل انتشارها" do
    render "shared/modal"
    selectable_column
    column :id
    column :permit
    column :last_seen_user
    column :request_sent_to_user
    column :permission_sent_to_photographer
    column "frame" do |sc|
      if sc.permit == true
        link_to admin_frame_path(sc.frame.id) do
          image_tag sc.frame.file_url(:light), style: "width:100px;"
        end
      else
        "محافظت شده"
      end
    end
    column "image" do |img|
      if img.permit == true
        link_to "Source", img.frame.file_url
      else
        "محافظت شده"
      end
    end
    column "selectable images" do |f|
      if f.permit == true
        link_to("انتخاب تصویر", select_frame_form_admin_galleries_path(image_id: f.frame.id, image_type: "Frame"), class: "btn btn-success btn-large", remote: true)
      else
        "محافظت شده"
      end
    end
    column "shoot type" do |sc|
      if sc.frame.present?
        link_to sc.frame.gallery.project.shoot_type.title, admin_shoot_type_path(sc.frame.gallery.project.shoot_type)
      end
    end
    column "Gallery" do |sc|
      if sc.frame.present?
        link_to sc.frame.gallery.project.user.display_name, admin_gallery_path(sc.frame.gallery)
      end
    end
    column :created_at
    column :updated_at
    actions
  end
end
