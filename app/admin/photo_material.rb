ActiveAdmin.register_page "PhotoMaterial" do
  menu parent: "Project", priority: 14
  content title: "Photo Material" do
    columns do
      column do
        panel "Photo Material", class: "rtl text-center" do
          columns do
            column do
              render partial: "photos"
            end
          end
        end
      end
    end
  end
end
