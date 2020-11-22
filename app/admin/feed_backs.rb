ActiveAdmin.register FeedBack do
  menu parent: "Project", priority: 6
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :qrate, :arate, :description, :project_id, :publishable, :used_mask

  filter :project, as: :select, collection: Project.all.confirmed.sort_by { |p| p.id }.map { |u| ["#{u.slug}-u.photographer.display_name", u.id] }
  filter :photographer
  filter :qrate
  filter :arate
  filter :description

  form do |f|
    f.inputs "Information" do
      f.input :project, :as => :select, :collection => Project.all.confirmed.sort_by { |e| e[:id] }.map { |u| [u.slug, u.id] }
      f.input :qrate
      f.input :arate
      f.input :description
      f.input :publishable
      f.input :used_mask
    end
    f.actions
  end

  show do
    div do
      attributes_table do
        row :project
        row :qrate
        row :description
        row :publishable
        row :used_mask
      end
    end
    panel "supervisor rate" do
      div class: "text-center" do
        link_to "new supervisor rate", new_admin_supervisor_rate_path(:supervisor_rate => { :admin_user_id => current_admin_user.id, :feed_back_id => feed_back.id }), class: "btn btn-primary"
      end
      table_for feed_back.supervisor_rates do
        column :admin_user
        column :rate
        column :description
      end
    end
    active_admin_comments
  end

  #
  # panel "Camera" do
  #   if photographer.equipment.present?
  #     table_for photographer.equipment.cameras do
  #       column :brand, :class => 'h4'
  #       column :model, :class => 'h4'
  #     end
  #   end
  # end
  #
  index do
    selectable_column
    column :id
    toggle_bool_column :publishable
    column :used_mask
    column :project
    column :qrate
    column :arate
    column :description
    column :created_at
    column :updated_at
    actions
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
