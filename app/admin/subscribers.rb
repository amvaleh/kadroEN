ActiveAdmin.register Subscriber do
  menu parent: "User", priority: 1

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email
  #
  # or
  #
  # permit_params do
  #   permitted = [:email]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
