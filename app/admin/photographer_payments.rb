ActiveAdmin.register PhotographerPayment do
  menu label: "Ph Payment"
  menu priority: 9

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :status, :photographer_id, :project_id, :payment_type, :price, :payment_date, :admin_user, :cashout_id, :bank_gateway_id, :track_code, :inquiry_at, :checkout_request_at, :jibit_uid

  scope :checked_out_but_not_ended

  before_action :set_date, only: [:update, :create]
  after_action :log_create_activity, only: :create
  before_action :log_destroy_activities, only: :destroy

  controller do
    def log_create_activity
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: PhotographerPayment.last
    end

    def log_destroy_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: PhotographerPayment.find(params[:id])
    end
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  #

  filter :project, as: :select, collection: Project.joins(:photographer_payments).collect { |p| [p.slug, p.id] }.uniq
  filter :price
  filter :status, as: :select, collection: Lookup.where(category: "payment_status").collect { |l| [l.title, l.code] }
  filter :photographer
  filter :payment_type
  filter :payment_date
  filter :error_messages
  filter :deposit_referrer
  filter :cashout_id
  filter :created_at
  filter :updated_at
  filter :bank_gateway
  filter :jibit_uid

  index do
    div do
      render "dashboard"
    end
    selectable_column
    column :id
    column :status_title
    column :photographer
    column :project
    column :invoice
    column :payment_type_title
    column "price" do |p|
      p.price.to_i
    end
    column "User" do |p|
      if p.project.present? and p.project.user.present?
        link_to p.project.user.display_name, admin_user_path(p.project.user)
      end
    end
    column :error_messages
    column :deposit_referrer
    column :uid
    column :jibit_uid
    column :created_at
    column "start time of project" do |p|
      if p.project.present?
        convert_persian_day(p.project.start_time.strftime("%A")).to_s + " " + p.project.start_time.to_date.to_pdate.strftime("%e %b").to_s + " ساعت " + p.project.start_time.strftime("%H:%M")
      end
    end
    column "project duration" do |p|
      if p.project.present?
        # p.project.package.duration
      end
    end
    column :cashout_id
    column :payment_date
    column :inquiry_at
    column :checkout_request_at
    column :bank_gateway
    actions
  end

  form do |f|
    f.input :admin_user, input_html: { value: "#{current_admin_user.id}" }, as: :hidden

    f.inputs "" do
      f.input :project_id, as: :select, collection: Project.payed.all.collect { |p| [p.slug, p.id] }
      f.input :status, as: :select, collection: Lookup.where("category = ?", "payment_status").collect { |s| [s.title, s.code] }
      f.input :photographer, :as => :select, :collection => Photographer.all.collect { |u| [u.display_name, u.id] }
      f.input :payment_type, as: :select, collection: Lookup.where("category = ?", "payment_type").collect { |s| [s.title, s.code] }
      f.input :price
      f.input :cashout_id
      f.input :jibit_uid
      f.input :bank_gateway
    end
    f.inputs "تاریخ" do
      f.input :payment_date, as: :datepicker
    end

    f.actions
  end

  controller do
    def set_date
      if params[:photographer_payment][:payment_date] == ""
        params[:photographer_payment][:payment_date] = nil
      else
        params[:photographer_payment][:payment_date] = "#{params[:photographer_payment][:payment_date]} 00:00:00".in_time_zone("Tehran")
      end
    end
  end

  ActiveAdmin.register PhotographerPayment do
    batch_action :checkout do |ids|
      result = PhotographerPayments::BatchPayment.call(ids: ids)
      redirect_to collection_path, notice: result.message
    end
  end
end
