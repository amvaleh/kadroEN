ActiveAdmin.register_page "Crm" do
  menu label: "CRM Panel", parent: "Project", priority: 0
  content title: "CRM Panel" do
    columns do
      column do
        panel "آمار پروژه ها", class: "rtl text-center" do
          render "crm"
        end
      end
    end
  end
end
