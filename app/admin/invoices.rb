ActiveAdmin.register Invoice do
  actions :all, :except => [:destroy]
  menu parent: "Shop", priority: 1

  permit_params :status, :vch_number, :track_code, :authority, :cart, :address, :service_step_id, :service_step, :postal_code, :provider_invoice_number

  csv do
    column :id
    column ("user payments") { |p| Invoices::CurrentInvoiceTotal.call(invoice: p, status: p.status).invoice_total.to_i }
    column ("cost") { |p| Invoices::CurrentInvoiceCost.call(invoice: p, status: p.status).invoice_total.to_i }
    column ("kadro profit") { |p| (Invoices::CurrentInvoiceTotal.call(invoice: p, status: p.status).invoice_total - Invoices::CurrentInvoiceCost.call(invoice: p, status: p.status).invoice_total).to_i }
    column :vch_number
    column :track_code
    column :authority
    column :service_step_id
  end

  after_action :log_create_activity, only: :create
  before_action :log_other_activities, only: [:update, :destroy]

  controller do
    def log_create_activity
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Invoice.last
    end

    def log_other_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Invoice.find(params[:id])
    end
  end

  index :title => "فاکتورهای چاپ" do
    selectable_column
    column :id
    column "user payed" do |p|
      Invoices::CurrentInvoiceTotal.call(invoice: p, status: p.status).invoice_total.to_i
    end
    column "cost" do |p|
      Invoices::CurrentInvoiceCost.call(invoice: p, status: p.status).invoice_total.to_i
    end
    column "profit" do |p|
      (Invoices::CurrentInvoiceTotal.call(invoice: p, status: p.status).invoice_total - Invoices::CurrentInvoiceCost.call(invoice: p, status: p.status).invoice_total).to_i
    end
    column :vch_number
    column :cart
    column :coupon
    column :address
    column :postal_code do |p|
      p.address.postal_code if p.address.present? and p.address.postal_code.present?
    end
    column :phone_number do |p|
      p.address.phone_number if p.address.present? and p.address.phone_number.present?
    end
    column :created_at
    column :updated_at
    column :status
    column :track_code
    column :authority
    column :service_step
    column :provider_invoice_number
    actions
  end

  show do
    div span: 2 do
      attributes_table do
        row :vch_number
        row :cart
        row :coupon
        row :address
        row "Projects" do |p|
          render partial: "show_projects", locals: { inv: p.id }
        end
        row :postal_code do |p|
          p.address.postal_code if p.address.present? and p.address.postal_code.present?
        end
        row :phone_number do |p|
          p.address.phone_number if p.address.present? and p.address.phone_number.present?
        end
        row :created_at
        row :updated_at
        row :status
        row :track_code
        row :provider_invoice_number
        row :authority
        row :service_step
        row "سفارش" do |p|
          render partial: "invoices/invoice", locals: { inv: p.id }
        end
        # row "جزئیات" do |p|
        #   render partial: 'invoices/invoice_show', locals: {cart_id: p.id}
        # end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Information" do
      f.input :service_step
      f.input :vch_number
      f.input :status
      f.input :track_code
      f.input :authority
      f.input :provider_invoice_number
    end
    f.actions
  end

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

end
