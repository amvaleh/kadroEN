ActiveAdmin.register CallRequest do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :phone_number, :call_time, :max_budget, :description, :complete
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :phone_number, :call_time, :max_budget, :description, :complete]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    toggle_bool_column :complete
    column :name
    column :phone_number
    column :call_time
    column :max_budget
    column :description
    column :created_at
    actions
  end

end
