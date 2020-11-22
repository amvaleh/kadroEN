ActiveAdmin.register Experience do
  permit_params :photographer_id, :years_been_photographer, :has_payed_work, :projects_payed_count, :self_describe, :bio, :passion, :love_job, :favorite_shoots, :shoots, :city_shoots, :awards, :fun_fact

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  menu parent: "Photographer", priority: 11
  after_action :log_create_activity, only: :create
  before_action :log_other_activities, only: [:update, :destroy]

  controller do
    def log_create_activity
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Experience.last
    end

    def log_other_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Experience.find(params[:id])
    end
  end

  form do |f|
    f.inputs "Information" do
      f.input :photographer #, :as => :select, :collection => Photographer.all.sort_by{|e| e[:first_name]}.sort_by{ |a| a.approved ? 0 : 1 }.map{|u| [u.display_name + u.pointer , u.id]}
      f.input :years_been_photographer
      f.input :projects_payed_count
      f.input :has_payed_work
      f.input :self_describe
      f.input :bio
      f.input :passion
      f.input :love_job
      f.input :favorite_shoots
      f.input :shoots
      f.input :city_shoots
      f.input :awards
      f.input :fun_fact
    end
    f.actions
  end
end
