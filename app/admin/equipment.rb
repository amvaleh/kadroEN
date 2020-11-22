ActiveAdmin.register Equipment do
  menu parent: "Photographer", priority: 9
  permit_params :id, :light_studio_kit, :portable_studio_kit, :portable_light, :large_product_kit, :small_product_kit
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  after_action :log_create_activity, only: :create
  before_action :log_other_activities, only: [:update, :destroy]
  controller do
    def log_create_activity
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Equipment.last
    end

    def log_other_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Equipment.find(params[:id])
    end
  end

  show do
    h2 equipment.photographer.display_name

    panel "details" do
      table_for equipment do
        column :small_product_kit
        column :large_product_kit
        column :portable_light
        column :portable_studio_kit
        column :light_studio_kit
      end
    end

    panel "lenzs" do
      table_for equipment.lenzs do
        column :brand
        column :model
      end
    end

    panel "camera" do
      table_for equipment.cameras do
        column :brand
        column :model
      end
    end
    active_admin_comments
  end

  index :title => "تجهیزات عکاسی" do
    selectable_column
    column :id
    column :photographer
    column :small_product_kit
    column :large_product_kit
    column :portable_light
    column :portable_studio_kit
    column :light_studio_kit
    column "دوربین ها", span: 5 do |p|
      p.cameras.map { |x| x.brand + x.model }.join("\n")
    end
    column "لنز ها" do |p|
      p.lenzs.map { |x| x.brand + x.model }.join("\n")
    end
    actions
  end

  form do |f|
    f.inputs "Information" do
      f.input :photographer, :as => :select, :collection => Photographer.all.sort_by { |e| e[:first_name] }.sort_by { |a| a.approved ? 0 : 1 }.map { |u| [u.display_name + u.pointer, u.id] }
      f.input :small_product_kit
      f.input :large_product_kit
      f.input :portable_light
      f.input :portable_studio_kit
      f.input :light_studio_kit
    end
    f.actions
  end
end
