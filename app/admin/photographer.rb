ActiveAdmin.register Photographer do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #

  menu parent: "Photographer", priority: 0
  permit_params :uid, :join_step_id, :email, :first_name, :last_name, :avatar, :location_id, :ideal_hours, :mobile_number, :approved, :static_number, :instagram, :linkedin, :rejected, :bank_account_id, :business_id, :password, :password_confirmation, :twitter, :qrate, :arate, :checked, :admin_user, :interview_date, :promissory, :contract, :has_studio, :callable, :grade_id, :internal_number, :gender , :auto_book
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  before_action :set_password_nil, only: [:update]
  before_action :log_activities, only: [:destroy]

  controller do
    def log_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Photographer.find_by(slug: params[:id])
    end
  end

  ActiveAdmin.register Photographer do
    batch_action :male do |ids|
      result = Photographers::BatchGender.call(ids: ids, gender: "male")
      redirect_to collection_path, notice: result.message
    end
    batch_action :female do |ids|
      result = Photographers::BatchGender.call(ids: ids, gender: "female")
      redirect_to collection_path, notice: result.message
    end
  end

  # config.batch_actions = false
  collection_action :filter_waiting_photographers, method: :get do
    if params[:photographers].present?
      cities = params[:photographers][:city_name]
      @photographers = Photographer.joins(:join_step).where(join_steps: { name: "در انتظار مصاحبه" }).joins(:location).where(locations: { city_name: cities }).order(last_step_at: :desc)
    else
      @photographers = Photographer.joins(:join_step).joins("left join locations l on l.id = location_id
        left join cities c on l.city_id = c.id where (c.name != 'تهران' and join_steps.name = 'در انتظار مصاحبه')")
    end
    respond_to do |format|
      format.js
    end
  end

  config.per_page = 50
  scope :all, default: true
  scope :approved
  scope :rejected
  scope :completing
  scope :checked
  scope :not_checked

  filter :shoot_types
  filter :internal_number
  filter :has_studio
  filter :gender, as: :select, collection: [["female", 1], ["male", 2]]
  filter :join_step
  filter :grade
  filter :business
  filter :first_name
  filter :last_name
  filter :created_at
  filter :updated_at
  filter :mobile_number
  filter :email
  filter :ideal_hours
  filter :slug
  filter :instagram
  filter :linkedin
  filter :birthday
  filter :auto_book

  csv do
    column :id
    column :first_name
    column :last_name
    column :updated_at
    column :gender
    column :uid
    column :has_studio
    column :approved
    column :rejected
    column :ideal_hours
    column ("Join Step") { |p| p.join_step.name if p.join_step.present? }
    column ("City") { |p| p.location.city.name if p.location.present? and p.location.city.present? }
    column ("Area") { |p| p.location.area_name if p.location.present? }
    column ("pro link") { |p| "https://pro.kadro.co/#{p.uid}" if p.uid.present? }
    column ("admin link") { |p| "https://app.kadro.co/admin/photographers/#{p.slug}" }
    column ("bank name") { |p| p.bank_account.bank_name if p.bank_account.present? }
    column ("bank shaba") { |p| p.bank_account.shaba if p.bank_account.present? }
    column ("bank card") { |p| p.bank_account.card_number if p.bank_account.present? }
    column ("Profile Create Date") { |p| p.created_at.to_time.strftime "%Y%m" }
    column :mobile_number
    column :internal_number
    column :callable
    column :email
    column :instagram
    column :linkedin
    column :twitter
    column :online_portfolio
    column ("years been ph ") { |p| p.experience.years_been_photographer if p.experience.present? }
    column ("has payed_work ") { |p| p.experience.has_payed_work if p.experience.present? }
    column ("projects payed count ") { |p| p.experience.projects_payed_count if p.experience.present? }

    column ("QRATE ") { |p| Photographers::Analyze::PhotographerRate.call(photographer_id: p.id).qrate }
    column ("ARATE ") { |p| Photographers::Analyze::PhotographerRate.call(photographer_id: p.id).arate }

    #column ("Number of kadro projects ") {|p| Photographers::Analyze::PhotographerProjectsCount.call(photographer_id: p.id).projects_number}

    #column ("Number of kadro customers ") {|p| Photographers::Analyze::PhotographerCustomersCount.call(photographer_id: p.id).customers_number}
    #column ("Hours of kadro photography ") {|p| Photographers::Analyze::PhotographyDurationTotal.call(photographer_id: p.id).total_time}

    #column ("Number of kadro project photos uploaded") {|p| Photographers::Analyze::PhotographerUploadedFramesCount.call(photographer_id: p.id).frames_number}
    #column ("Number of frames customers downloaded") {|p| Photographers::Analyze::PhotographerFramesDownloadsCount.call(photographer_id: p.id).download_number}
    #column ("Number of times suggested to users ") {|p| Photographers::Analyze::PhotographerSuggestionTimes.call(photographer_id: p.id).suggestion_times}

    #column ("Amount of Revenue from kadro") {|p| Photographers::Analyze::PhotographerTotalIncome.call(photographer_id: p.id).total_income}
  end

  show do
    div span: 2 do
      attributes_table do
        row "email confirmed" do |p|
          if p.confirmed?
            span "تایید شده در#{p.confirmed_at.to_date.to_pdate}"
          else
            span "تایید نشده"
          end
        end
        row :checked
        row :approved
        row :approved_at do |p|
          p.approved_at.to_date.to_pdate if p.approved_at.present?
        end
        row :rejected
        row :auto_book
        row :has_studio
        row "studio location" do |p|
          if p.active_studio.present?
            link_to p.active_studio.approved, admin_shoot_location_path(p.active_studio)
          else
            link_to "ایجاد استودیوی عکاس", new_admin_shoot_location_path(:shoot_location => { :photographer_id => p.id })
          end
        end
        row "Gender" do |p|
          if p.gender == 1
            span "زن"
          elsif p.gender == 2
            span "مرد"
          end
        end
        row :join_step
        row :grade
        row "avatar" do |p|
          if p.avatar.present?
            image_tag p.avatar_url(:medium)
          end
        end
        row :interview_date
        row "UID" do |p|
          if p.uid.present?
            link_to p.uid, p.pro_url, :class => "btn btn-blue", target: "_blank"
          end
        end
        row :mobile_number
        row :static_number
        row :internal_number
        row :callable
        row :email
        row :promissory
        row :contract
        row :birthday do |e|
          e.birthday.to_date.to_pdate if e.birthday.present?
        end
        row :ideal_hours
        row "instagram" do |p|
          if p.instagram.present?
            link_to p.instagram, "https://www.instagram.com/#{p.instagram}/", :class => "btn btn-blue", target: "_blank"
          end
        end
        row :online_portfolio
        row :linkedin
        row :twitter
        row "Card Name" do |p|
          if p.bank_account.present?
            span p.bank_account.card_name
            span link_to "Edit", edit_admin_bank_account_path(p.bank_account.id), :class => "btn btn-blue"
            span link_to "show", admin_bank_account_path(p.bank_account.id), :class => "btn btn-blue"
          end
        end
        row :qrate
        row :arate
        row "معرف" do |p|
          if p.parent.present?
            # span p.parent.display_name
            span link_to "#{p.parent.display_name}", admin_photographer_path(p.parent.mobile_number), :class => "btn btn-blue"
          end
        end
        row "ایمیل های ارسال شده" do |p|
          if p.sent_photographer_emails.present?
            # span p.parent.display_name
            span "#{p.sent_photographer_emails.count}"
          end
        end
        row "ایمیل های باز شده" do |p|
          if p.sent_photographer_emails.present?
            # span p.parent.display_name
            span "#{p.sent_photographer_emails.opened.count}"
          end
        end
        row "تعداد بازدید از ایمیل ها" do |p|
          if p.sent_photographer_emails.present?
            # span p.parent.display_name
            count = 0
            p.sent_photographer_emails.opened.each do |f|
              count = count + f.number_of_seen
            end
            span "#{count}"
          end
        end
        #active_admin_comments
      end
    end

    panel "Camera" do
      if photographer.equipment.present?
        table_for photographer.equipment.cameras do
          column :brand, :class => "h4"
          column :model, :class => "h4"
        end
      end
    end

    panel "Lenz" do
      if photographer.equipment.present?
        table_for photographer.equipment.lenzs do
          column :brand, :class => "h4"
          column :model, :class => "h4"
        end
      end
    end

    panel "Other Equipment" do
      div style: "font-size: 20px; color: dodgerblue; margin-bottom: 10px" do
        "All kit types are:"
      end
      div class: "row" do
        Kit.all.each_with_index do |kit, index|
          div class: "col-md-3" do
            (index + 1).to_s + ") " + kit.title
          end
        end
      end
      div style: "font-size: 20px; color: dodgerblue; margin-top: 15px" do
        "which photographer has following: "
      end
      if photographer.equipment.present?
        table_for photographer.equipment do
          if photographer.equipment.kits.present?
            photographer.equipment.kits.each do |kit|
              column kit.title
            end
          end
        end
      end
    end

    # panel "Work samples", :class => 'h4' do
    #   columns do
    #     photographer.expertises.each do |e|
    #       column do
    #         span e.shoot_type.title
    #         div do
    #           e.approved
    #         end
    #         div do
    #           link_to "Edit", edit_admin_expertise_path(e), :class => "btn btn-default"
    #         end
    #         div do
    #           link_to "Delete", admin_expertise_path(e), :method => :delete, :class => "btn btn-default"
    #         end
    #         div do
    #           @photos = e.photos
    #           render partial: "work_sample", locals: {photos: @photos}
    #         end
    #       end
    #     end
    #   end
    # end
    expertises = photographer.expertises
    panel "نمونه کارها", class: "rtl text-center" do
      counter = 1
      expertises.each do |expertise|
        attributes_table_for expertise do
          row expertise.shoot_type.title do
            div class: "text-center col-xs-10" do
              render partial: "show_expertise_photos", locals: { photos: expertise.photos, counter: counter, expertise: expertise }
            end
            div class: "text-center col-xs-2" do
              div do
                link_to expertise.approved.to_s, admin_expertise_path(expertise), :class => "btn btn-default btn-block"
              end
              div do
                link_to "Edit", edit_admin_expertise_path(expertise), :class => "btn btn-default btn-block"
              end
              div do
                link_to "Delete", admin_expertise_path(expertise), :method => :delete, :class => "btn btn-default btn-block"
              end
            end
          end
        end
        counter = counter + 1
      end
    end

    render partial: "shared/modal"

    if photographer.experience.present?
      panel "Experience", class: "rtl text-center" do
        attributes_table_for photographer.experience do
          row :years_been_photographer
          row :has_payed_work
          row :projects_payed_count
          row :self_describe
          row :bio
          row :passion
          row :love_job
          row :favorite_shoots
          row :shoots
          row :city_shoots
          row :awards
          row :fun_fact
          row "edit" do
            link_to "ویرایش", edit_admin_experience_path(photographer.experience), target: "_blank", :class => "btn btn-default"
          end
        end
      end
    end
    expertise_widgets = ExpertiseWidget.joins(:expertise => :photographer).where(photographers: { id: photographer.id })
    if expertise_widgets.any?
      panel "اکسسوری", class: "rtl text-center" do
        expertise_widgets.each do |expertise_widget|
          attributes_table_for expertise_widget do
            row expertise_widget.expertise.shoot_type.title do
              div class: "text-center col-xs-8" do
                span link_to expertise_widget.widget.name, admin_widget_path(expertise_widget.widget), target: "_blank"
              end
              div class: "text-center col-xs-2" do
                link_to "ویرایش", edit_admin_expertise_widget_path(expertise_widget), target: "_blank", :class => "btn btn-default btn-block"
              end
              div class: "text-center col-xs-2" do
                link_to "مشاهده", admin_expertise_widget_path(expertise_widget), target: "_blank", :class => "btn btn-primary btn-block", :style => "color: white;"
              end
            end
            if expertise_widget.expertise_widget_attachments.present?
              row "تصاویر #{expertise_widget.widget.name}" do
                render partial: "show_expertise_widget_attachment", locals: { expertise_widget: expertise_widget }
              end
            end
          end
        end
      end
    end

    panel "Free Times" do
      if photographer.free_times.present?
        @free_times = photographer.free_times.sort_by { |x| [x.day] }
        @data = []
        @week_days = [1, 2, 3, 4, 5, 6, 7]
        @free_times.each do |free_time|
          @week_days.each do |week_day|
            if free_time.day > week_day
              start_time = free_time.start.strftime("07:00").to_time
              end_time = free_time.start.strftime("07:00").to_time
              day = helpers.convert_persian_number_day(week_day, true)
              @data.push [day, start_time, end_time]
            elsif free_time.day == week_day
              start_time = free_time.start.strftime("%H:%M").to_time
              end_time = free_time.end.strftime("%H:%M").to_time
              day = helpers.convert_persian_number_day(free_time.day, true)
              @data.push [day, start_time, end_time]
            else
              start_time = free_time.start.strftime("24:00").to_time
              end_time = free_time.start.strftime("24:00").to_time
              day = helpers.convert_persian_number_day(week_day, true)
              @data.push [day, start_time, end_time]
            end
          end
        end
        render partial: "free_times", locals: { data: @data }
      end
    end

    attributes_table do
      div class: "btn btn-info", type: "button", "data-toggle" => "collapse", "data-target" => "#collapseProjects" do
        "کلیک کنید"
      end

      div class: "row collapse", id: "collapseProjects" do
        render partial: "show_recent_project_for_photographer", locals: { projects: photographer.projects }
      end
    end

    panel "payments", class: "h3" do
      div class: "btn btn-info", type: "button", "data-toggle" => "collapse", "data-target" => "#collapseOne" do
        "کلیک کنید"
      end
      div class: "collapse", id: "collapseOne" do
        if photographer.photographer_payments.present?
          div class: "row" do
            photographer.photographer_payments.order(created_at: :desc).each do |p|
              div class: "col-md-3" do
                colour = p.status == 3 ? "cbffc7" : "f3f5a085"
                div class: "payed-cart", style: "background-color: ##{colour}; padding: 12px; margin-bottom: 15px;font-size: 15px" do
                  div class: "col-md-6", style: "color: #5d7d9c" do
                    div class: "row", style: "margin-bottom: 6px" do
                      p.price.to_i
                    end
                    div class: "row", style: "margin-bottom: 6px" do
                      Lookup.find_by(code: p.status, category: "payment_status").title
                    end
                    div class: "row", style: "margin-bottom: 6px" do
                      Lookup.find_by(code: p.payment_type, category: "payment_type").title
                    end
                    div class: "row", style: "margin-bottom: 6px" do
                      p.payment_date
                    end
                    div class: "row", style: "margin-bottom: 6px" do
                      p.deposit_referrer
                    end
                  end
                  div class: "col-md-6", style: "color:#ca7070; text-align:right" do
                    div class: "row", style: "margin-bottom: 6px" do
                      ":مبلغ"
                    end
                    div class: "row", style: "margin-bottom: 6px" do
                      ":وضعیت پرداخت"
                    end
                    div class: "row", style: "margin-bottom: 6px" do
                      ":بابت"
                    end
                    div class: "row", style: "margin-bottom: 6px" do
                      ":زمان پرداخت"
                    end
                    div class: "row", style: "margin-bottom: 12px" do
                      ":شماره پیگیری"
                    end
                  end
                  div class: "row col-xs-offset-4", style: "margin-bottom: 6px" do
                    link_to User.joins(:projects).where("projects.id = ?", p.project_id)[0].full_name, admin_project_path(Project.find_by(id: p.project_id).slug), class: "btn btn-default"
                  end
                  div class: "row col-md-offset-1", style: "color: slategrey; font-size: 13px" do
                    p.created_at
                  end
                end
              end
            end
          end
        end
      end
    end

    active_admin_comments
  end

  sidebar "Details", only: :show, :class => "table-left" do
    attributes_table_for photographer do
      row :location do |p|
        hr
        a "living:#{p.location.living_input}", href: "https://www.google.com/maps/dir/Current+Location/#{p.location.living_lat},#{p.location.living_long}", target: :_blank if p.location.present? and p.location.living_input.present? and p.location.living_lat.present? and p.location.living_long.present?
        hr
        a "working:#{p.location.working_input}", href: "https://www.google.com/maps/dir/Current+Location/#{p.location.working_lat},#{p.location.working_long}", target: :_blank if p.location.present? and p.location.working_input.present? and p.location.working_lat.present? and p.location.working_long.present?
        hr
        if p.location.present?
          p.location.area_name
        end
      end
      row :location
      row "مدارک شناسایی" do |p|
        hr
        a "شناسنامه", href: p.scanned_profile.birthـcertificate_url if p.scanned_profile.present?
        hr
        a "کارت ملی", href: p.scanned_profile.national_card_url if p.scanned_profile.present?
      end
      row :current_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_at
      row :last_sign_in_ip
      row :created_at
      row :updated_at
    end
  end

  index do
    selectable_column
    column :id
    column "نام", sortable: :last_name do |p|
      span p.first_name.to_s + " " + p.last_name.to_s
    end
    column "email confirmed" do |p|
      if p.confirmed?
        span "تایید شده در#{p.confirmed_at.to_date.to_pdate}"
      else
        span "تایید نشده"
      end
    end
    column :updated_at, sortable: :updated_at
    column :uid
    column "Gender" do |p|
      if p.gender == 1
        span "زن"
      elsif p.gender == 2
        span "مرد"
      end
    end
    column :grade, sortable: :grade
    toggle_bool_column :approved
    toggle_bool_column :has_studio
    toggle_bool_column :auto_book
    column "Studio location" do |p|
      if p.active_studio.present?
        link_to p.active_studio.approved, admin_shoot_location_path(p.active_studio)
      else
        link_to "ایجاد استودیوی عکاس", new_admin_shoot_location_path(:shoot_location => { :photographer_id => p.id })
      end
    end

    column :approved_at do |p|
      p.approved_at.to_date.to_pdate if p.approved_at.present?
    end
    toggle_bool_column :rejected
    column :checked
    column :ideal_hours
    column :join_step, sortable: :join_step
    column "عکس" do |p|
      link_to p.avatar_url(:large) do
        image_tag p.avatar_url(:mini) if p.avatar?
      end
    end
    column :mobile_number
    column :email
    column :equipment do |p|
      p.equipment if p.equipment.present?
    end
    column :experience do |p|
      p.experience if p.experience.present?
    end
    column "Select_Shoot_type" do |p|
      div do
        p.expertises.each do |e|
          ul do
            span e.shoot_type.title
            span e.photos.count
          end
        end
      end
    end
    column "عکاس معرف" do |p|
      p.parent if p.parent.present?
    end
    column :rate, sortable: :rate
    column "instagram" do |p|
      if p.instagram.present?
        link_to p.instagram, "https://www.instagram.com/#{p.instagram}/", :class => "btn btn-blue", target: "_blank"
      end
    end
    column :linkedin
    actions
  end

  form do |f|
    f.input :admin_user, input_html: { value: "#{current_admin_user.id}" }, as: :hidden

    f.inputs "Position" do
      f.input :grade, as: :select, collection: Grade.all.sort_by { |p| p.id }.map { |u| [u.title, u.id] }
      f.input :join_step, as: :select, collection: JoinStep.all.sort_by { |p| p.id }.map { |u| [u.name, u.id] }
      f.input :gender, as: :select, collection: [["female", 1], ["male", 2]]
      f.input :checked
      f.input :approved
      f.input :rejected
      f.input :has_studio
      f.input :promissory
      f.input :contract
      f.input :callable
      f.input :auto_book
    end
    f.inputs "Interview Time" do
      f.input :interview_date, as: :date_time_picker
    end
    f.inputs "Detail" do
      f.input :uid
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :mobile_number
      f.input :static_number
      f.input :internal_number
      f.input :avatar
      f.input :ideal_hours
      f.input :online_portfolio
      f.input :instagram
      f.input :linkedin
      f.input :twitter
      f.input :location, :label => "Location", :as => :select, :collection => Location.all.map { |u| [u.living_input, u.id] }
      f.input :bank_account_id
      f.input :business
      f.input :qrate
      f.input :arate
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def set_password_nil
      if params[:photographer][:password] == ""
        params[:photographer][:password] = nil
        params[:photographer][:password_confirmation] = nil
      end
    end
  end
end
