ActiveAdmin.register Photo do
  menu parent: "Photographer", priority: 15
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  permit_params :expertise_id, :file
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index :title => "نمونه عکسهای عکاس" do
    selectable_column
    column :id
    column :file
    column :exif
    column "photo" do |p|
      link_to p.file.url do
        image_tag(p.file.url(:thumb))
      end
    end
    column :created_at
    column :updated_at
    column :expertise
    actions
  end

  show do
    attributes_table do
      # photo.file
      div do
        link_to photo.file.url, photo.file.url
      end
      div do
        link_to photo.file.url(:thumb), photo.file.url(:thumb)
      end
      div do
        link_to photo.file.url(:large), photo.file.url(:large)
      end
      row("shoot_type?") { photo.expertise.shoot_type }
      row :expertise
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Details" do
      f.input :expertise_id, :label => "Expertise", :as => :select, :collection => Expertise.all.where(:photographer_id => f.photo.expertise.photographer).map { |u| ["#{u.photographer.first_name}, #{u.shoot_type.title}", u.id] }
    end
    f.actions
  end
end
