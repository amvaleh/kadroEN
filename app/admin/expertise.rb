ActiveAdmin.register Expertise do
  menu parent: "Photographer", priority: 12
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :shoot_type_id, :photographer_id, :approved, samples: []
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  after_action :log_create_activity, only: :create
  before_action :log_other_activities, only: [:update, :destroy]

  controller do
    def log_create_activity
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Expertise.last
    end

    def log_other_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Expertise.find(params[:id])
    end
  end

  filter :photographer
  filter :shoot_type
  filter :samples
  filter :approved
  filter :approved_photographer, as: :boolean
  filter :order

  form(:html => { :multipart => true }) do |f|
    f.inputs "" do
      f.input :shoot_type
      f.input :photographer, :as => :select #, :collection => Photographer.all.sort_by{|e| e[:first_name]}.sort_by{ |a| a.approved ? 0 : 1 }.map{|u| [u.display_name + u.pointer , u.id]}
      f.input :samples, as: :file, :input_html => { :multiple => true }
      f.input :approved
    end
    f.actions
  end

  index :title => "تخصص ها" do
    selectable_column
    column :id
    toggle_bool_column :approved
    column :shoot_type
    column :photographer
    column "self upload" do |e|
      ul style: "display:flex" do
        e.photos.each do |s|
          li do
            span do
              image_tag s.file_url(:thumb)
            end
            span do
              link_to "view", admin_photo_path(s), target: "_blank"
            end
            span do
              link_to "exif", admin_exif_path(s.exif), target: "_blank" if s.exif.present?
            end
          end
        end
      end
    end
    actions
  end
end
