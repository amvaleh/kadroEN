ActiveAdmin.register User do
  menu parent: "User", priority: 0
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :email, :mobile_number, :first_name, :last_name, :company_name, :repeated_times, :business_id, :lead_source_id, :admin_user, :slug, :full_name, :birthday_date, :call_date, :is_called, :password
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  before_action :log_activities, only: :destroy
  before_action :fix_date, only: [:create, :update]

  controller do
    def log_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: User.friendly.find(params[:id])
    end

    def fix_date
      if params[:user][:call_date].present?
        params[:user][:call_date].tr!("/۰۱۲۳۴۵۶۷۸۹", "-0123456789")
        t = params[:user][:call_date]
        date = t.to_pdate.to_date.to_time.strftime("%Y-%m-%d ")
        final = (date).to_date
        params[:user][:call_date] = final
      end
      if params[:user][:password] == nil
        params[:user][:password] = "123456"
      end
    end
  end

  filter :business
  filter :lead_source
  filter :mobile_number
  filter :full_name
  filter :company_name
  filter :created_at
  filter :updated_at
  filter :current_sign_in_at
  filter :last_sign_in_at
  filter :email
  filter :birthday_date
  filter :is_called
  filter :call_date

  csv do
    column :id
    column :slug
    column :mobile_number
    column :display_name
    column :company_name
    column :email
    column ("Lead Source") { |u| u.lead_source.title if u.lead_source.present? }
    column ("Business") { |u| u.business.name if u.business.present? }

    column :created_at
    column :updated_at
    column :sign_in_count
    column :current_sign_in_at
    column :last_sign_in_at
    column :last_sign_in_ip
    column ("#Coupon Redemnption") { |u| u.coupon_redemptions.count if u.coupon_redemptions.any? }

    column ("# Sent User Emails") { |p| p.sent_user_emails.count if p.sent_user_emails.any? }

    # column ("Longest Reserve Step"){|p| p.join_step.name if p.join_step.present?  }

    column ("#payed projects") { |u| u.projects.payed.count if u.projects.any? }
    column ("#incompelete projects") { |u| u.projects.not_payed.count if u.projects.any? }
    column ("#Print Order Attempts ") { |u| u.carts.count if u.carts.any? }

    column ("proj itvr tm") { |u| (u.projects.payed.last.created_at.to_pdate.to_date - u.projects.payed.first.created_at.to_pdate.to_date).to_i if u.projects.any? and u.projects.payed.any? }

    column ("#Receipts") { |u| u.receipts.count }
  end

  form do |f|
    f.input :admin_user, input_html: { value: "#{current_admin_user.id}" }, as: :hidden

    f.inputs "User Info" do
      render partial: "input_for_mobile_number", locals: { user: object }
      f.input :email
      f.input :full_name
      f.input :company_name
      f.input :birthday_date
    end

    f.inputs "Lead Source" do
      f.input :business
      f.input :lead_source
      f.input :call_date, as: :string
      f.input :is_called
    end
    f.inputs "User Passowrd" do
      f.input :repeated_times
      render partial: "javascript_for_persian_date", locals: { user: f }
    end
    f.actions
  end

  show do
    panel "Analytics" do
      attributes_table_for user.visits.first do
        row(:landing_page) { |v| link_to(v.landing_page, v.landing_page) if v.landing_page }
        row(:referrer) { |v| link_to(v.referrer, v.referrer) if v.referrer }
        row("Time to Signup") { |v| distance_of_time_in_words(v.user.created_at.to_pdate.to_date, v.started_at) }
        row(:location)
        row(:technology)
        row(:utm_source)
        row(:utm_medium)
        row(:utm_term)
        row(:utm_content)
        row(:utm_campaign)
      end
      attributes_table do
        row "Visits" do |p|
          link_to "All Visits", admin_ahoy_visits_path(q: { user_id_eq: user.id }), target: "_blank"
        end
        row "Actions" do |p|
          link_to "All Actions", admin_ahoy_events_path(q: { user_id_eq: user.id }), target: "_blank"
        end
        row "Send Message" do |p|
          link_to "Send Message", new_admin_message_path(:message => { :mobile_number => user.mobile_number, :body => user.display_name + " عزیز" }), class: "btn btn-primary"
        end
      end
    end
    panel "credit detail" do
      div class: "text-center" do
        link_to "new credit detail", new_admin_credit_detail_path(:credit_detail => { :user_mobile_number => user.mobile_number }), class: "btn btn-primary"
      end
	if user.credit.present?
      table_for user.credit.credit_details do
        column :value
        column :credit_detail_type
        column :credit
      end
	end
    end
    div span: 2 do
      attributes_table do
        row :display_name
        row :company_name
        row :mobile_number
        row :email
        row :credit
        row :refer
        row :is_called
        row "تاریخ تماس" do |p|
          "#{p.call_date.to_date.to_pdate}-#{p.call_date.to_date.to_pdate.strftime("%A")}" unless p.call_date.nil?
        end
        row :reset_password_token
        row :birthday_date
        row :sign_in_count
        row :current_sign_in_at
        row :repeated_times
        row :business
        row :lead_source
        row :reset_password_token
        row "ایمیل های ارسال شده" do |p|
          if p.sent_user_emails.present?
            # span p.parent.display_name
            span "#{p.sent_user_emails.count}"
          end
        end
        row "ایمیل های باز شده" do |p|
          if p.sent_user_emails.present?
            # span p.parent.display_name
            span "#{p.sent_user_emails.opened.count}"
          end
        end
        row "تعداد بازدید از ایمیل ها" do |p|
          if p.sent_user_emails.present?
            # span p.parent.display_name
            count = 0
            p.sent_user_emails.opened.each do |f|
              count = count + f.number_of_seen
            end
            span "#{count}"
          end
        end
        row "پروژه های پرداخت شده" do |p|
          render partial: "show_recent_payed_project_for_user", locals: { data: p }
        end
        row "پروژه های پرداخت نشده" do |p|
          render partial: "show_recent_not_payed_project_for_user", locals: { data: p }
        end
        row "خرید های فروشگاه" do |p|
          render partial: "carts/carts_list", locals: { carts: p.carts }
        end
      end
    end
    active_admin_comments
  end
end
