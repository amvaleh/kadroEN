ActiveAdmin.register Package do
  menu parent: "Project", priority: 2
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :photographer_commission, :is_full, :title, :duration, :price, :digitals, :order, :extra_price, :shoot_type_id, :is_active, :rational_distance, :name, :vip, :vip_url, :feature_1, :feature_2, :feature_3, :feature_4, :feature_5, :feature_6, :feature_7, :description, :real_price, :extra_credit
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    column :id
    column :shoot_type
    toggle_bool_column :is_active
    toggle_bool_column :is_full
    column :title
    column :duration
    column :price
    column :digitals
    column :extra_price
    column :order
    column :photographer_commission
    column :shoot_type_id
    column :rational_distance
    column :name
    column :vip
    column :vip_url
    column :extra_credit
    column :description
    actions defaults: true do |package|
      link_to "Duplicate", clone_admin_package_path(package, package), class: "view_link member_link"
    end
  end

  after_action :log_create_activity, only: :create
  before_action :log_other_activities, only: [:update, :destroy]

  member_action :clone, method: :get do
    @package = resource.dup
    render :new, layout: false
  end

  controller do
    def log_create_activity
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Package.last
    end

    def log_other_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Package.find(params[:id])
    end
  end
end
