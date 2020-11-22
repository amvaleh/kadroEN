ActiveAdmin.register RedirectRule do
  menu label: "Redirector", parent: "General Settings", priority: 1
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :source, :source_is_regex, :source_is_case_sensitive, :destination, :active
  #
  # or
  #
  # permit_params do
  #   permitted = [:source, :source_is_regex, :source_is_case_sensitive, :destination, :active]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
