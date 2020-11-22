ActiveAdmin.register ShootLocation do
  menu parent: "Kadro Land", priority: 0
  before_action :address_check, only: [:update, :create]
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :photographer_id, :shoot_location_type_id, :is_studio, :approved, :address_id, :title, :description
  #
  # or
  #
  # permit_params do
  #   permitted = [:photographer_id, :location_type_id, :in_studio, :approved]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  controller do
    def address_check
      if params[:action] == "create"
        address = Addresses::CreateAddress.call(lattitude: params[:shoot_location][:latitude], longtitude: params[:shoot_location][:longitude], input: params[:shoot_location][:input], detail: params[:shoot_location][:detail]).address
        params[:shoot_location][:address_id] = address.id
      else
        address = Addresses::UpdateAddress.call(id: params[:shoot_location][:address_id], lattitude: params[:shoot_location][:latitude], longtitude: params[:shoot_location][:longitude], input: params[:shoot_location][:input], detail: params[:shoot_location][:detail]).address
      end
    end
  end

  form do |f|
    f.inputs "Shoot Location" do
      f.input :title
      f.input :description
      f.input :photographer
      f.input :shoot_location_type
      f.input :is_studio
      f.input :approved
      f.input :address, :wrapper_html => { :style => "display: none;" }
      render partial: "map_input", locals: { object: object }
    end
    f.actions
  end

  show do
    div span: 2 do
      attributes_table do
        row :title
        row :description
        row :slug
        row :photographer
        row :shoot_location_type
        row :is_studio
        row :approved
        render partial: "map_show", locals: { object: shoot_location }
        row :address
        row "Detail" do |p|
          if p.address.present?
            p.address.detail
          end
        end
        row :created_at
        row :updated_at
        render partial: "attachment_uploader", locals: { object: shoot_location }
      end
    end
    active_admin_comments
  end
end
