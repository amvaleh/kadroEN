ActiveAdmin.register FreeTime do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :day, :start, :end, :photographer_id, :photographer
  menu parent: "Photographer", priority: 1
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
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: FreeTime.last
    end

    def log_other_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: FreeTime.find(params[:id])
    end
  end

  index :title => "زمان های همکاری عکاسان" do
    selectable_column
    column :id
    column :day
    column "روز" do |p|
      "#{WeekDay.find_by(:order => p.day).name}" unless p.day.nil?
    end
    column "از" do |p|
      "#{p.start.strftime("%H:%M")}" unless p.start.nil?
    end
    column "تا" do |p|
      "#{p.end.strftime("%H:%M")}" unless p.end.nil?
    end
    column :photographer
    actions
  end
  form do |f|
    f.inputs "Create New" do
      f.input :photographer_id, :label => "Photographer", :as => :select, :collection => Photographer.all.approved
      f.input :day, :label => "day", :as => :select, :collection => WeekDay.all.map { |u| [u.name, u.order] }
      f.input :start
      f.input :end
    end
    f.actions
  end
end
