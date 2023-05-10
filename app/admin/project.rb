ActiveAdmin.register Project do
  permit_params :extrahour_total, :reserve_step_id, :delivery_at_location, :is_payed, :has_gallery, :confirmed,
                :start_time, :start_date, :business_id, :start_hour_id, :week_day_id, :photographer_id, :shoot_type_id,
                :package_id, :coupon_id, :user_id, :receipt_id, :address_id, :feedback_channel_id, :shoot_detail, :is_shooted,
                :is_uploaded, :checked_out, :send_customer, :extend_hours, :print_order, :extra_download, :passed_72hour, :send_customer_at,
                :extra_hour_requested, :first_call, :publishable, :rate_reminder_sent, :call_status_id, :change_loop_times, :direct_book,
                :in_studio, :card_to_card, :lead_source_id, :admin_user_id, :current_admin_user, :qualified_at, :payment_by_credit, :search_for_studio

  menu parent: "Project", priority: 1
  before_action :log_activities, only: [:destroy]
  before_action :changed_form, only: [:update]

  controller do
    def log_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Project.find_by(slug: params[:id])
    end

    def changed_form
      if params[:project][:start_time].present?
        params[:project][:start_time].tr!("/۰۱۲۳۴۵۶۷۸۹", "-0123456789")
        t = params[:project][:start_time]
        hour = t.to_time.strftime("%H:%M:%S")
        date = t.to_pdate.to_date.to_time.strftime("%Y-%m-%d ")
        final = (date + hour).to_time.in_time_zone("Tehran").in_time_zone("UTC")
        params[:project][:start_time] = final
      end
      if params[:project][:package_id].present? && params[:project][:shoot_type_id].present?
        sh = ShootType.find_by_id(params[:project][:shoot_type_id])
        p = Package.find_by_id(params[:project][:package_id])
        pks = sh.packages
        if !pks.find_by_id(p.id).present?
          final_package = pks.find_by(:duration => p.duration, :is_full => p.is_full, :is_active => true)
          if final_package.present?
            params[:project][:package_id] = final_package.id
          else
            params[:project][:package_id] = nil
          end
        end
      end
    end
  end

  collection_action :project_details, method: :get do
    if params[:project_id]
      project = Project.find(params[:project_id])

      activities = Activities::GetProjectActivities.call(project: project).activities
      comments = ActiveAdminComments::GetProjectComments.call(project: project).comments
      render locals: { project: project, activities: activities, comments: comments }
    end
  end

  config.per_page = 50
  scope :all, default: true
  scope :package_is_vip
  scope :finished
  scope :confirmed
  scope :payed
  scope :shooted
  scope :has_gallery
  scope :uploaded
  scope :send_customer
  scope :checked_out
  scope :publishable

  # filter :photographer # , :as => :select, :collection => Photographer.all.sort_by{|e| e[:first_name]}.sort_by{ |a| a.approved ? 0 : 1 }.map{|u| [u.display_name + u.pointer , u.id]}
  filter :reserve_step
  filter :admin_user
  # filter :user, :as => :select, :collection => User.all.sort_by { |e| e[:mobile_number] }.map { |u| [u.mobile_number, u.id] }
  filter :coupon
  filter :package
  filter :shoot_type
  filter :business
  filter :feedback_channel
  filter :created_at
  filter :shoot_detail
  filter :slug
  filter :is_payed
  filter :confirmed
  filter :is_shooted
  filter :is_uploaded
  filter :send_customer
  filter :passed_72hour
  filter :has_gallery
  filter :checked_out
  filter :start_time
  filter :delivery_at_location
  filter :extend_hours
  filter :extra_download
  filter :print_order
  filter :lead_source
  filter :search_for_studio
  filter :payment_by_credit

  csv do
    column :id
    #    column :admin_user do |p|
    #     p.admin_user.email
    #    end
    column "زمان شروع" do |p|
      "#{p.start_time.to_date.to_pdate}-#{p.start_time.to_date.to_pdate.strftime("%A")} - #{p.start_time.strftime("ساعت %I:%M%p")}" unless p.start_time.nil?
    end
    column :created_at
    column (:shoot_type) { |p| p.shoot_type.title if p.shoot_type.present? }
    column ("package full") { |p| p.package.is_full if p.package.present? }
    column ("duration") { |p| p.package.order if p.package.present? }
    column ("package price") { |p| p.package.price if p.package.present? }

    column ("receipt total") { |p| p.receipt.total if p.receipt.present? }

    column ("receipt subtotal") { |p| p.receipt.subtotal if p.receipt.present? }

    # column ("likely discount") { |p| p.package.price.to_i + p.receipt.extrahour_total.to_i + p.receipt.filedownload_total.to_i + p.receipt.print_total.to_i - p.receipt.subtotal.to_i if p.receipt.present? and p.package.present? }

    column ("kadro share total") { |p| "#{p.receipt.subtotal.to_i - p.receipt.ph_payment.to_i}" if p.receipt.present? }

    # column ("kadro total") { |p| p.profit_for_kadro }

    # column ("extra download count") { |p| p.extra_download }
    # column ("extra hour count") { |p| p.extend_hours }
    # column ("print count") { |p| p.print_order }

    column ("shoot type type") { |p| p.shoot_type.is_personal if p.shoot_type.present? }

    # column ("extra download total") { |p| p.receipt.filedownload_total if p.receipt.present? }
    # column ("extra hour total") { |p| p.receipt.extrahour_total if p.receipt.present? }
    # column ("print total") { |p| p.receipt.print_total if p.receipt.present? }

    column ("ph payment") { |p| p.receipt.ph_payment if p.receipt.present? }
    column ("Coupon Title") { |p| p.coupon.title if p.coupon.present? }
    column ("Coupon Value") { |p| p.coupon.value if p.coupon.present? }
    column ("Coupon Is Percent") { |p| p.coupon.is_percent if p.coupon.present? }
    column (:photographer) { |p| p.photographer.display_name if p.photographer.present? }
    column (:user) { |p| p.user.display_name if p.user.present? }
    column ("user mobile_number") { |p| p.user.mobile_number if p.user.present? }
    # column ("user prev projects") { |p| p.user.projects.payed.count if p.user.projects.any? }
    column ("user email") { |p| p.user.email if p.user.present? }
    # column ("Number of frames ") { |p| p.gallery.frames.count if p.gallery.present? and p.gallery.frames.any? }
    # column ("Number of downloaded frames ") { |p| p.gallery.frames.downloaded.count if p.gallery.present? and p.gallery.frames.any? }
    column ("admin project") { |p| admin_project_url(p) }
    column ("user lead source") { |p| p.user.lead_source.title if p.user.present? && p.user.lead_source.present? }
    column ("Feedback channel") { |p| p.feedback_channel.title if p.feedback_channel.present? }
    column ("project visit") { |p| "#{p.ahoy_visit.utm_source} | #{p.ahoy_visit.utm_medium} | #{p.ahoy_visit.utm_term} | #{p.ahoy_visit.utm_campaign} |" if p.ahoy_visit.present? }
    column ("user visit") { |p| "#{p.user.first_visit.utm_source} | #{p.user.first_visit.utm_medium} | #{p.user.first_visit.utm_term} | #{p.user.first_visit.utm_campaign} |" if p.user.present? && p.user.first_visit.present? }
  end

  index :title => "پروژه ها" do
    selectable_column
    column :id
    column :admin_user
    # column "AdminUser" do |p|
    #   AdminUser.find(p.admin_user_id).display_name
    # end
    column "Analytics" do |p|
      if p.ahoy_visit_id.present?
        link_to p.ahoy_visit_id, admin_ahoy_visit_path(p.ahoy_visit_id)
      end
    end
    column :call_status
    column "User Lead" do |p|
      p.user.lead_source.title if p.user.present? and p.user.lead_source.present?
    end
    column "User" do |p|
      if p.user.present?
        link_to p.user.display_name, admin_user_path(p.user)
      end
    end
    column :reserve_step
    column :first_call
    column "تحویل در محل" do |p|
      p.delivery_at_location
    end
    column :feedback_channel

    column "زمان درخواست" do |p|
      "#{p.start_time.to_date.to_pdate}-#{p.start_time.to_date.to_pdate.strftime("%A")} - #{p.start_time.strftime("ساعت %I:%M%p")}" unless p.start_time.nil?
    end
    column "زمان ایجاد" do |p|
      "#{p.created_at}" unless p.created_at.nil?
    end
    column :photographer, sortable: :email
    column :shoot_type, sortable: :shoot_type_id
    column "Package" do |p|
      link_to p.package.title + "-" + p.package.photos_count + "-" + p.package.duration, admin_package_path(p.package) if p.package.present?
    end
    column :coupon, sortable: :coupon_id

    column :receipt do |p|
      if p.receipt.present?
        link_to p.receipt.subtotal.to_s + "-" + p.receipt.track_code.to_s, admin_receipt_path(p.receipt)
      end
    end
    column :shoot_detail
    column "user info" do |p|
      link_to "***", thank_you_project_path(p), target: :_blank
    end
    column "ph info" do |p|
      link_to "***", project_information_project_path(p), target: :_blank
    end
    column :address do |p|
      if p.address.present?
        link_to Location, admin_address_path(p.address)
      end
    end
    column "Map" do |p|
      if p.address.present?
        link_to "Go_To ", "https://www.google.com/maps/dir/Current+Location/#{p.address.lattitude},#{p.address.longtitude}", target: :_blank
      end
    end
    column :start_time
    column "Gallery" do |p|
      link_to "مشاهده #{p.gallery.frames.count} عکس", admin_gallery_path(p.gallery), target: :_blank unless p.gallery.nil?
    end
    column "برخورد عکاس" do |p|
      if p.feed_back.present?
        link_to "#{p.feed_back.arate}", admin_feed_back_path(p.feed_back.id), target: :_blank
      end
    end
    column "کیفیت عکس" do |p|
      if p.feed_back.present?
        link_to "#{p.feed_back.qrate}", admin_feed_back_path(p.feed_back.id), target: :_blank
      end
    end
    column :in_studio
    column :is_payed
    column :confirmed
    column :is_shooted
    column :passed_72hour
    column :has_gallery
    column :is_uploaded
    column :send_customer
    column :checked_out
    column :search_for_studio
    column :extend_hours
    column :print_order
    column :extra_download
    column :rate_reminder_sent
    column :change_loop_times
    actions
  end

  form do |f|
    f.input :current_admin_user, input_html: { value: "#{current_admin_user.id}" }, as: :hidden

    f.inputs "Status" do
      f.input :reserve_step
      f.input :call_status
      f.input :lead_source
      if !object.admin_user.present? and object.reserve_step_id.in?([1, 2, 3, 4, 5, 6])
        f.input :admin_user_id, :as => :select, :collection => AdminUser.all.map { |u| [u.email, u.id] }, selected: "#{object.admin_user.present? ? object.admin_user.id : current_admin_user.id}"
      end
      f.input :delivery_at_location
      f.input :first_call
      # f.input :card_to_card
      f.input :payment_by_credit
      f.input :is_payed
      f.input :confirmed
    end

    f.inputs "Other" do
      f.input :is_shooted
      f.input :has_gallery
      f.input :is_uploaded
      f.input :send_customer
      f.input :checked_out
      f.input :passed_72hour
      f.input :in_studio
      f.input :rate_reminder_sent
      f.input :direct_book
    end

    f.inputs "آیا پروژه قابل انتشار است؟" do
      f.input :publishable
    end

    f.inputs "Photographer & Shoot Type" do
      f.input :photographer, :as => :select, :collection => Photographer.all.sort_by { |a| a.approved ? 0 : 1 }.map { |u| [u.display_name + u.pointer, u.id] }
      div :class => "container" do
        h5 "candidates:"
        div :class => "row", style: "direction: rtl;" do
          if project.project_candidates.any?
            project.project_candidates.order("priority").each do |p|
              div :class => "well col-xs-3" do
                span "(#{p.priority}) - "
                a href: admin_photographer_path(p.photographer), target: "_blank" do
                  "#{p.photographer.display_name}-"
                end
                span "km #{p.distance.round}-"
                span "#{p.price} تومن-"
                if p.project_candidate_status.title == "rejected"
                  span class: "alert-danger" do
                    "#{p.project_candidate_status.title}"
                  end
                elsif p.project_candidate_status.title == "accepted"
                  span class: "alert-success" do
                    "#{p.project_candidate_status.title}"
                  end
                else
                  span class: "alert-info" do
                    "#{p.project_candidate_status.title}"
                  end
                end
                if p.reason_for_reject.present?
                  span class: "alert-danger" do
                    "#{p.reason_for_reject.name}"
                  end
                end
              end
            end
          end
        end
      end

      f.input :shoot_type
      if object.shoot_type.present?
        f.input :package, :label => "Package", :as => :select, :collection => Package.active.all.where(shoot_type_id: f.project.shoot_type.id).map { |u| [u.display_name, u.id] }
      else
        f.input :package
      end
      f.input :user, :label => "User", :as => :select, :collection => User.all.sort_by { |e| e[:mobile_number] }.map { |u| [u.mobile_number, u.id] }
    end
    f.inputs "Time" do
      f.input :start_time, as: :string
      f.input :send_customer_at, as: :date_time_picker
      f.input :created_at, as: :date_time_picker
      f.input :qualified_at, as: :date_time_picker
    end
    f.inputs "Other" do
      f.input :extend_hours
      f.input :extra_hour_requested
      f.input :print_order
      f.input :extra_download
      f.input :coupon_id, :label => "Coupon", :as => :select, :collection => Coupon.all.where(is_percent: true).map { |u| [u.title, u.id] }
      f.input :business
      f.input :slug
      f.input :shoot_detail
      f.input :change_loop_times
      f.input :feedback_channel
      render partial: "javascript_for_persian_date", locals: { project: f }
    end
    # f.input :photographer_id, :label => 'Expertise', :as => :select, :collection => Expertise.all.where(:photographer_id => f.photo.expertise.photographer).map{|u| ["#{u.photographer.first_name}, #{u.shoot_type.title}", u.id]}
    f.actions
  end

  show do
    panel "Analytics" do
      attributes_table_for project.visit do
        row(:landing_page) { |v| link_to(v.landing_page, v.landing_page) if v.landing_page }
        row(:referrer) { |v| link_to(v.referrer, v.referrer) if v.referrer }
        row("Time to Create") { |v| distance_of_time_in_words(v.project.created_at.to_pdate.to_date, v.started_at) }
        row(:location)
        row(:technology)
        row(:utm_source)
        row(:utm_medium)
        row(:utm_term)
        row(:utm_content)
        row(:utm_campaign)
      end
    end
    div span: 2 do
      attributes_table do
        row "Admin User" do |p|
          AdminUser.find_by(id: p.admin_user_id)
        end
        row "Details" do |p|
          render partial: "link_to_details", locals: { project: p }
        end
        row "Thank you" do |p|
          link_to "Thank_you page", thank_you_project_path(p)
        end
        row :lead_source
        row :reserve_step
        row :first_call
        row :call_status
        row :rate_reminder_sent
        row :publishable
        row :is_payed
        row :is_payed_at
        row :card_to_card
        row :payment_by_credit
        row :confirmed
        row :is_shooted
        row :has_gallery
        row :is_uploaded
        row :send_customer
        row :checked_out
        row :passed_72hour
        row :in_studio
        row :delivery_at_location
        row :search_for_studio
        row :rate_reminder_sent
        row :photographer
        row :shoot_type
        row "Package" do |p|
          if p.package.present?
            link_to "#{p.package.title}", admin_package_path(p.package_id)
          end
        end
        row :user
        row :gallery
        row :start_time
        row :created_at
        row :receipt
        row :coupon
        row :slug
        row :business
        row :feedback_channel
        row :extend_hours
        row :extra_hour_requested
        row :extra_download
        row :print_order
        row :shoot_detail
        row :change_loop_times
        row "Address" do |p|
          if p.address.present?
            link_to "جزیات آدرس", admin_address_path(p.address_id)
          end
        end
        row "نظر کاربر در مورد عکاس" do |p|
          if p.feed_back.present?
            if p.feed_back.qrate.present?
              span "کیفیت عکاس :"
              # span p.parent.display_name
              span "#{p.feed_back.qrate}"
            else
              span "کیفیت عکاس :"
              # span p.parent.display_name
              span "وارد نشده"
            end
            if p.feed_back.arate.present?
              span "-- برخورد عکاس :"
              # span p.parent.display_name
              span "#{p.feed_back.arate}"
            else
              span "-- برخورد عکاس :"
              # span p.parent.display_name
              span "وارد نشده."
            end
            if p.feed_back.description.present?
              span "-- توضیحات :"
              # span p.parent.display_name
              span "#{p.feed_back.description}"
            else
              span "-- توضیحات :"
              # span p.parent.display_name
              span "وارد نشده."
            end
          end
        end
        row "ایمیل های ارسال شده" do |p|
          if p.sent_project_emails.present?
            # span p.parent.display_name
            span "#{p.sent_project_emails.count}"
          end
        end
        row "ایمیل های باز شده" do |p|
          if p.sent_project_emails.present?
            # span p.parent.display_name
            span "#{p.sent_project_emails.opened.count}"
          end
        end
        row "تعداد بازدید از ایمیل ها" do |p|
          if p.sent_project_emails.present?
            # span p.parent.display_name
            count = 0
            p.sent_project_emails.opened.each do |f|
              count = count + f.number_of_seen
            end
            span "#{count}"
          end
        end
        row :send_customer_at
        row :qualified_at
        row "User Feedback" do |p|
          if p.user_feedback.present?
            link_to "نظر عکاس", admin_user_feedback_path(p.user_feedback.id)
          end
        end

        row "Project Feedback" do |p|
          if p.feed_back.present?
            link_to "نظر کاربر", admin_feed_back_path(p.feed_back.id)
          end
        end
      end
      panel "credit detail" do
        div class: "text-center" do
          link_to "new credit detail", new_admin_credit_detail_path(:credit_detail => { :project_slug => project.slug, :user_mobile_number => project.user.mobile_number }), class: "btn btn-primary"
        end
        table_for project.credit_details do
          column :value
          column :credit_detail_type
          column :credit
        end
      end
    end
    active_admin_comments
  end

  before_update do |project|
    if project.reserve_step_id_changed? && project.reserve_step.name == "canceled_payment"
      payments = PhotographerPayment.where(project_id: project.id).load
      payments.each do |p|
        PhotographerPayments::PhotographerPaymentUpdate.call(id: p.id, photographer_payment_data: { status: 4 })
      end
    end

    if project.photographer_id_changed?
      payments = PhotographerPayment.where(project_id: project.id).load
      payments.each do |p|
        PhotographerPayments::PhotographerPaymentUpdate.call(
          id: p.id,
          photographer_payment_data: { photographer_id: project.photographer_id },
        )
      end
    end
  end
end
