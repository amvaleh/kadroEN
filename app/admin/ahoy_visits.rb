ActiveAdmin.register Ahoy::Visit do

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
  menu parent: "Dashboard", priority: 6
  index do
    selectable_column
    column :id
    column :ip
    column :user
    column :referrer
    column :referring_domain
    column :landing_page
    column :utm_source
    column :utm_medium
    column :utm_campaign
    column :utm_term
    column :utm_content
    column :started_at
    column :user_agent
    column :browser
    column :os
    column :device_type
    actions
  end
end
