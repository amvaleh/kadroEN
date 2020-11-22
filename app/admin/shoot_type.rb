ActiveAdmin.register ShootType do
  # menu false
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :title, :avatar, :order, :is_business, :is_personal, :is_active, :recommended_hours, :w_url, :w_subtitle, :w_title, :delivery_deadline_hours, :half_hour_extend_cost, :max_frame_size, :min_frame_size, :ideas_url, samples: []
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
  menu parent: "General Settings", priority: 3
  controller do
    def log_create_activity
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: ShootType.last
    end

    def log_other_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: ShootType.find(params[:id])
    end
  end

  show do
    div span: 2 do
      attributes_table do
        row :is_active
        row :title
        row :order
        row :is_personal
        row :is_business
        row :recommended_hours
        row :delivery_deadline_hours
        row :w_url
        row :w_subtitle
        row :w_title
        row :avatar
        row :half_hour_extend_cost
        row :max_frame_size
        row :min_frame_size
        row "Handy Photos" do |f|
          div do
            @samples = f.samples
            render partial: "samples", locals: { samples: @samples }
          end
        end
      end
    end
  end

  form(:html => { :multipart => true }) do |f|
    f.inputs "Basic" do
      f.input :is_active
      f.input :title
      f.input :order
      f.input :is_personal
      f.input :is_business
      f.input :recommended_hours
      f.input :delivery_deadline_hours
      f.input :ideas_url
      f.input :half_hour_extend_cost
      f.input :max_frame_size
      f.input :min_frame_size
    end

    f.inputs "Files" do
      f.input :avatar, as: :file
      f.input :samples, as: :file, :input_html => { :multiple => true }
    end

    f.inputs "wordpress configs" do
      f.input :w_url
      f.input :w_subtitle
      f.input :w_title
    end

    f.actions
  end
end
