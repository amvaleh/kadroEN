ActiveAdmin.register_page "Dashboard" do

  # menu priority: 1, label: "Dashboard"
  menu parent: "Dashboard", priority: 2
  content title: "Dashboard" do
    if current_admin_user.role == "admin" && current_admin_user.role == "support"
      columns do
        column do
          panel "آمار پروژه ها", class: "rtl text-center" do
            render partial: "project_analyze_charts"
          end
        end
      end

      columns do
        column do
          panel "آمار عکاسان", class: "rtl text-center" do
            render partial: "photographer_analyze_charts"
          end
        end
      end

      columns do
        column do
          panel "آمار ایمیل ها", class: "rtl text-center" do
            render partial: "email_analyze_charts"
          end
        end
      end

      div class: "blank_slate_container", id: "dashboard_default_message" do
        panel "مناطق پروژه ها", class: "rtl text-center" do
          div do
            render "home_projects"
          end
        end
        panel "مناطق عکاسان ثبت نامی", class: "rtl text-center" do
          div do
            render "home_photographers"
          end
        end
      end

      columns do
        column do
          panel "آمار رشته ها", class: "rtl text-center" do
            render partial: "expertise_share_status"
          end
        end
      end
    elsif current_admin_user.role == "coworker"
      user_projects = Project.joins(:user => :business).where(:users => { :business_id => current_admin_user.business.id }, :businesses => { :admin_user_id => current_admin_user.id })
      photographer_projects = Project.joins(:photographer => :business).where(:photographers => { :business_id => current_admin_user.business.id }, :businesses => { :admin_user_id => current_admin_user.id })
      if user_projects.present? && photographer_projects.present?
        total = user_projects | photographer_projects
        columns do
          column do
            panel "آمار پروژه های شما", class: "rtl text-center" do
              puts "هم عکاس هم کاربر"
              render partial: "coworkers_projects", locals: { rows: total }
            end
          end
        end
      elsif user_projects.present?
        columns do
          column do
            panel "آمار پروژه های شما", class: "rtl text-center" do
              render partial: "coworkers_projects", locals: { rows: user_projects }
              puts "فقط کاربر"
            end
          end
        end
      elsif photographer_projects.present?
        columns do
          column do
            panel "آمار پروژه های شما", class: "rtl text-center" do
              render partial: "coworkers_projects", locals: { rows: photographer_projects }
              puts "فقط عکاس"
            end
          end
        end
      else
        columns do
          column do
            panel "آمار پروژه های شما", class: "rtl text-center" do
              render partial: "coworkers_projects", locals: { rows: user_projects }
            end
          end
        end
      end

      if current_admin_user.business.photographers.present?
        columns do
          column do
            panel "آمار عکاس های شما", class: "rtl text-center" do
              render partial: "coworkers_photographers"
            end
          end
        end
      end

      if current_admin_user.business.users.present?
        columns do
          column do
            panel "آمار کاربران شما", class: "rtl text-center" do
              render partial: "coworkers_users"
            end
          end
        end
      end
    end
  end
end
