ActiveAdmin.register Partner do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  permit_params :title, :service, :website, :click_counter, :avatar
  #
  menu parent: "General Settings", priority: 4
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  show do
    div span: 2 do
      attributes_table do
        row :title
        row :service
        row :website
        row :click_counter
        row "avatar" do |p|
          if p.avatar.present?
            image_tag p.avatar_url(:medium)
          end
        end
      end
    end
  end
  form do |f|
    f.inputs "information of partner service provider:" do
      f.input :title
      f.input :service
      f.input :website
      f.input :click_counter
      f.input :avatar
    end
    f.actions
  end
end
