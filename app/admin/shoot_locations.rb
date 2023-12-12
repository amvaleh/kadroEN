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
        address = Addresses::CreateAddress.call(lattitude: params[:shoot_location][:latitude], longtitude: params[:shoot_location][:longitude], input: params[:shoot_location][:input], detail: params[:shoot_location][:title]).address
        params[:shoot_location][:address_id] = address.id
      else
        address = Addresses::UpdateAddress.call(id: params[:shoot_location][:address_id], lattitude: params[:shoot_location][:latitude], longtitude: params[:shoot_location][:longitude], input: params[:shoot_location][:input], detail: params[:shoot_location][:title]).address
        params[:shoot_location][:address_id] = address.id
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
      if object.address.present?
        if object.address.lattitude == ""
          lat = object.address.city.latitude
        else
        lat = object.address.lattitude
        end

        if object.address.longtitude == ""
          lng = object.address.city.longitude
        else
        lng = object.address.longtitude
        end
        
      else
        lat = "35.7219"
        lng = "51.3347"
      end
      render partial: "/shared/map_leaflet_input", locals: { object: object, map_id: "work_map", map_width: "100%", map_height: "400px", map_center_lat: lat , map_center_lng: lng, lat_input_name: "shoot_location[latitude]" , lng_input_name: "shoot_location[longitude]" }
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
        if shoot_location.address.present?
          render partial: "/shared/map_leaflet_show", locals: { lat: shoot_location.address.lattitude, lng: shoot_location.address.longtitude, map_width: "100%", map_height: "400px", dragging: true }
        end
        row "Address Detail" do |p|
          if p.address.present?
            link_to "#{p.address.detail}", admin_address_path(p.address.id)
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
