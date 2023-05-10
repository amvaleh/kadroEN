ActiveAdmin.register Business do
  menu parent: "General Settings", priority: 6
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  permit_params :name, :refers, :admin_user_id, :photographer_share, :user_share

  after_action :log_create_activity, only: :create
  before_action :log_other_activities, only: [:update, :destroy]

  controller do
    def log_create_activity
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Business.last
    end

    def log_other_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Business.find(params[:id])
    end
  end

  form do |f|
    f.inputs "Status" do
      # f.input :admin_user, :label => "Admin", :as => :select, :collection => AdminUser.all.sort_by { |e| e[:email] }.map { |u| [u.email, u.id] }
      f.input :name
      f.input :refers
      f.input :photographer_share
      f.input :user_share
    end
    f.actions
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
