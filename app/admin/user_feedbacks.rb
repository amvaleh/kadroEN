ActiveAdmin.register UserFeedback do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :arate, :project_id, :description
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  menu parent: "Photographer", priority: 6
  show do
    active_admin_comments
    panel "Results" do
      attributes_table_for user_feedback do
        row :id
        row :project
        row :photographer
        row :description
        table_for user_feedback.user_feedback_questions do
          column :user_feedback
          column (:feedback_question) { |user_feedback_question| user_feedback_question.feedback_question.question }
          column :value
        end
      end
    end
  end
end
