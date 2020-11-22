ActiveAdmin.register Receipt do
  menu parent: "Project", priority: 7
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  permit_params :total, :subtotal, :track_code, :coupon, :filedownload_total, :extrahour_total, :print_total, :extrahour_track_code, :extrahour_paid, :extra_paid, :coupon_id, :business_total, :business_checkout, :transportion_cost, :admin_user, :user, :user_id, :ph_payment

  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  after_action :log_create_activity, only: :create
  before_action :log_other_activities, only: :destroy

  controller do
    def log_create_activity
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Receipt.last
    end

    def log_other_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Receipt.find(params[:id])
    end
  end

  form do |f|
    f.input :admin_user, input_html: { value: "#{current_admin_user.id}" }, as: :hidden

    f.inputs "Receipt edit" do
      f.input :coupon
      f.input :total
      f.input :subtotal
      f.input :ph_payment
      f.input :transportion_cost
    end

    f.actions
  end
end
