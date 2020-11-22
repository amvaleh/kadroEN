ActiveAdmin.register Coupon do
  # menu false
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #

  permit_params :title, :value, :is_percent, :code, :is_active, :used_times, :valid_from, :valid_until, :redemption_limit, :number_of_repetitions, :is_first_order

  menu parent: "Coupon", priority: 0
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
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Coupon.last
    end

    def log_other_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Coupon.find(params[:id])
    end
  end

  form do |f|
    div class: "well rtl" do
      f.inputs "Create New" do
        f.input :title
        f.input :value
        f.input :code
        # f.input :used_times
        f.input :is_percent
        f.input :is_first_order
        f.input :is_active
        f.input :valid_from, as: :date_time_picker
        f.input :valid_until, as: :date_time_picker
        f.input :number_of_repetitions
        f.input :redemption_limit
      end
      f.actions
    end
  end

  show do
    div do
      attributes_table do
        row :title
        row :value
        row :code
        row :used_times
        row :is_percent
        row :is_first_order
        row :is_active
        row :valid_from
        row :valid_until
        row :number_of_repetitions
        row :redemption_limit
      end
    end
    panel "used in projects" do
      table_for coupon.projects do
        column "project link" do |project|
          link_to "#{project.slug}", admin_project_path(project.slug)
        end
        column :reserve_step
        column :is_payed
        column :confirmed
        column "Package" do |p|
          if p.package.present?
            link_to "#{p.package.title}-#{p.package.duration}", admin_package_path(p.package_id)
          end
        end
        column :user
        column "start time" do |project|
          convert_persian_day(project.start_time.strftime("%A")).to_s + " " + project.start_time.to_date.to_pdate.strftime("%e %b").to_s + " ساعت " + project.start_time.strftime("%H:%M")
        end
      end
    end
    active_admin_comments
  end
end
