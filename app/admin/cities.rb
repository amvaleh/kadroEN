ActiveAdmin.register City do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  menu parent: "General Settings", priority: 7
  permit_params :name, :eng_name, :description, :latitude, :longitude, :impression_discount_package
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
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: City.last
    end

    def log_other_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: City.find(params[:id])
    end
  end

  form do |f|
    f.inputs "Create New" do
      f.input :name
      f.input :eng_name
      f.input :description
      f.input :impression_discount_package
      f.input :latitude
      f.input :longitude
    end
    # f.inputs 'موقعیت مکانی' do
    #   render partial: "choose_location"
    # end
    f.actions
  end
end
