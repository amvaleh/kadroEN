ActiveAdmin.register Widget do
  menu parent: "Photographer", priority: 2
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :widget_type_id, :name, :description, :approved
  #
  # or
  #
  # permit_params do
  #   permitted = [:widget_type_id, :name, :description, :approved]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
