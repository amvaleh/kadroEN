ActiveAdmin.register ShootTypeLocation do
  menu label: "Proper Shoot Types", parent: "Kadro Land", priority: 2
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :shoot_location_id, :shoot_type_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:shoot_location_id, :shoot_type_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
