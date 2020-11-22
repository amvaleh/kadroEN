ActiveAdmin.register_page "analyze" do
  menu parent: "Dashboard", priority: 1

  content title: "Analyze" do
    columns do
      column do
        panel "وضعیت عکاسان", class: "rtl text-center" do
          columns do
            column do
              render partial: "photographers_analyze_calendar"
            end
          end
        end
      end
    end
  end
end
