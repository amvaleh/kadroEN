ActiveAdmin.register CreditDetail do
  menu parent: "User", priority: 3
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :value, :credit_id, :project_id, :credit_detail_type_id, :current_admin_user
  #
  # or
  #
  # permit_params do
  #   permitted = [:value, :project_id, :credit_detail_type_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  before_action :set_params, only: [:update, :create]

  filter :credit_detail_type
  filter :value
  filter :created_at
  filter :updated_at

  controller do
    def set_params
      if params[:credit_detail][:project_slug].present?
        p = Project.find_by(slug: params[:credit_detail][:project_slug])
        if p.present?
          params[:credit_detail][:project_id] = p.id
        end
      end
      if params[:user][:mobile_number].present?
        u = User.find_by(mobile_number: params[:user][:mobile_number])
        if u.present?
          params[:credit_detail][:credit_id] = u.credit.id
        end
      end
    end
  end

  form do |f|
    f.inputs "Form" do
      f.input :current_admin_user, input_html: { value: "#{current_admin_user.id}" }, as: :hidden
      # f.input :credit_id, :as => :select, :collection => Credit.all.map { |u| [ u.id , u.id] }
      render partial: "input_for_mobile_number", locals: { credit: object.credit }
      render partial: "input_for_project_slug", locals: { credit_detail: object }
      f.input :credit_detail_type
      f.input :value
    end
    f.actions
  end
end
