ActiveAdmin.register ReasonForReject do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :user_notice, :have_penalty, :priority, :display
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :user_notice, :have_penalty]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end


  filter :name
  filter :user_notice
  filter :have_penalty
  filter :priority
  filter :display

end
