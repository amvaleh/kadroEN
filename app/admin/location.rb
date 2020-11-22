ActiveAdmin.register Location do
  menu parent: "Photographer", priority: 20
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :living_address, :living_long, :living_lat, :working_long, :working_lat, :living_input, :working_input, :city_id, :city_name, :area_name
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
