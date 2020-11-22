ActiveAdmin.register ExpertiseWidget do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :expertise_id, :widget_id, :description, :approved
  menu parent: "Photographer", priority: 13
  #
  # or
  #
  # permit_params do
  #   permitted = [:expertise_id, :widget_id, :description, :approved]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
