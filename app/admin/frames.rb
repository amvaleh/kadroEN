ActiveAdmin.register Frame do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :downloaded, :downloaded_times, :file_name, :share_control_id, :retouched
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  before_action :log_activities, only: [:update, :destroy]

  controller do
    def log_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Frame.find(params[:id])
    end
  end

  menu parent: "Project", priority: 17
  filter :gallery_id
  filter :tag
  filter :width
  filter :height
  filter :size
  filter :downloaded
  filter :retouched
  filter :downloaded_times
  filter :created_at
  filter :file_name
  filter :resource_type

  index :title => "عکس های پروژه" do
    selectable_column
    column :id
    toggle_bool_column :downloaded
    column "share control" do |f|
      if f.share_control.present?
        f.share_control.permit
      end
    end
    toggle_bool_column :retouched
    toggle_bool_column :like
    column :gallery
    column :exif
    column :file
    column :original_filename
    column :width
    column :height
    column :size
    column "light" do |f|
      link_to f.file_url(:light), :target => "_blank" do
        image_tag f.file_url(:light), :width => 100
      end
    end
    column :downloaded
    column :downloaded_times
    column :tag
    column :created_at
    column :file_name
    column :resource_type
    actions
  end
end
