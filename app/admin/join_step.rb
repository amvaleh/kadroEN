ActiveAdmin.register JoinStep do
  menu parent: "General Settings", priority: 11
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :code
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
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: JoinStep.find(params[:id])
    end
  end
end
