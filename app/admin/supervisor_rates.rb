ActiveAdmin.register SupervisorRate do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :admin_user_id, :rate, :description, :feed_back_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:admin_user_id, :rate, :description, :feed_back_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  #

  form do |f|
    f.input :feed_back_id, :as => :select, :collection => FeedBack.all.map { |u| [u.display_name, u.id] }
    f.input :admin_user_id, :as => :select, :collection => AdminUser.all.map { |u| [u.display_name, u.id] }
      f.input :rate
      f.input :description
    f.actions
  end


end
