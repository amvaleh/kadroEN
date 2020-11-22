ActiveAdmin.register_page "sale_analyze" do
  menu parent: "Dashboard", priority: 0

  content title: "Sale Analyze" do
    columns do
      column do
        if !params[:start_date].present? and !params[:end_date].present?
          params[:end_date] = Time.now.to_date.to_pdate
          params[:start_date] = (Time.now - 30.days).to_date.to_pdate
        end
        unless params[:type].present?
          params[:type] = "confirmed"
        end
        start_date = params[:start_date].to_s.to_pdate.to_date.strftime("%Y-%m-%d")
        end_date = (params[:end_date].to_s.to_pdate.to_date.to_time + 1.days).to_date.strftime("%Y-%m-%d")
        lead_sources = LeadSources::SelectTopLeadSource.call(start_date: start_date, end_date: end_date, limit: 10).lead_sources
        # lead_sources = LeadSource.all
        admins = Admins::SelectTopAdmins.call(start_date: start_date, end_date: end_date, limit: 5).admins
        utm_sources = AhoyAnalyze::SelectTopUtmSources.call(start_date: start_date, end_date: end_date, limit: 5).utm_sources
        # admins = AdminUser.all

        panel "", class: "rtl text-center" do
          columns do
            column do
              render partial: "sale_analyze_filter", locals: { start_date: params[:start_date], end_date: params[:end_date] }
            end
          end
        end
        panel "", class: "rtl text-center" do
          columns do
            column do
              render partial: "sale_analyze_reasons", locals: { start_date: start_date, end_date: end_date }
            end
          end
        end
        panel "", class: "rtl text-center" do
          columns do
            column do
              render partial: "sale_analyze_lead_source_count", locals: { start_date: start_date, end_date: end_date, lead_sources: lead_sources }
            end
          end
        end
        panel "", class: "rtl text-center" do
          columns do
            column do
              render partial: "sale_analyze_admin_count", locals: { start_date: start_date, end_date: end_date, admins: admins }
            end
          end
        end
        panel "", class: "rtl text-center" do
          columns do
            column do
              render partial: "sale_analyze_count", locals: { start_date: start_date, end_date: end_date }
            end
          end
        end
        panel "", class: "rtl text-center" do
          columns do
            column do
              render partial: "sale_analyze_lead_source_chart_count", locals: { start_date: start_date, end_date: end_date, lead_sources: lead_sources }
            end
          end
        end
        panel "", class: "rtl text-center" do
          columns do
            column do
              render partial: "sale_analyze_lead_source_pie_chart_count", locals: { start_date: start_date, end_date: end_date, lead_sources: lead_sources }
            end
          end
        end
        panel "", class: "rtl text-center" do
          columns do
            column do
              render partial: "ahoy_analyze_charts", locals: { start_date: start_date, end_date: end_date, utm_sources: utm_sources }
            end
          end
        end
      end
    end
  end
end
