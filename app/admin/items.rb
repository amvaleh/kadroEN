ActiveAdmin.register Item do
  menu parent: "Shop", priority: 4

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :title, :price, :description, :item_type_id, :width, :height, :status, :cost
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  #

  after_action :log_create_activity, only: :create
  before_action :log_other_activities, only: [:update, :destroy]

  member_action :clone, method: :get do
    @item = resource.dup
    render :new, layout: false
  end

  controller do
    def log_create_activity
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Item.last
    end

    def log_other_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Item.find(params[:id])
    end
  end

  show do
    div span: 2 do
      attributes_table do
        row :title
        row :price
        row :cost
        row :description
        row :item_type
        row :created_at
        row :updated_at
        row :width
        row :height
        row :status do |e|
          e.status == 1 ? "فعال" : "غیر فعال"
        end
      end
    end
    active_admin_comments
  end

  index do
    selectable_column
    column :id
    column :title
    column :price
    column :cost
    column :description
    column :item_type
    column :created_at
    column :updated_at
    column :width
    column :height
    column :status do |e|
      e.status == 0 ? "غیر فعال" : "فعال"
    end
    # actions
    actions defaults: true do |item|
      link_to "Duplicate", clone_admin_item_path(item, item), class: "view_link member_link"
    end
  end

  form do |f|
    f.inputs "Detail" do
      f.input :title, :label => "title"
      f.input :price, :label => "مبلغ"
      f.input :cost, :label => "هزینه کادرو"
      f.input :item_type
      f.input :status, :label => "فعال یا غیر فعال بودن", :as => :select, :collection => { "فعال" => 1, "غیر فعال" => 0 }
      f.input :description
      f.input :width
      f.input :height
    end
    f.actions
  end
end
