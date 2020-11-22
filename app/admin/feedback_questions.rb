ActiveAdmin.register FeedbackQuestion do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :question_type, :name, :question_title, :question, :active
  menu parent: "Photographer", priority: 26
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  #
  #

  index do
    selectable_column
    column :id
    column :question_type
    column :name
    column :question_title
    column :question
    toggle_bool_column :active
  end

  after_action :log_create_activity, only: :create
  before_action :log_other_activities, only: [:update, :destroy]

  controller do
    def log_create_activity
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: FeedbackQuestion.last
    end

    def log_other_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: FeedbackQuestion.find(params[:id])
    end
  end
end
