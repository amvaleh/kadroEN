ActiveAdmin.register EquipmentKit do
  menu parent: "Photographer", priority: 24
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :equipment_id, :kit_id
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
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: EquipmentKit.last
    end

    def log_other_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: EquipmentKit.find(params[:id])
    end
  end
end
