ActiveAdmin.register GuidelinePackage do
  menu parent: "Project", priority: 3
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :package_id, :guideline_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:package_id, :guideline_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.inputs "Guideline Package" do
      f.input :package_id, :as => :select, :collection => Package.has_shoot_type.map { |u| ["#{u.shoot_type.title} - #{u.display_name} : #{u.id}", u.id] }
      f.input :guideline
    end
    f.actions
  end
end
