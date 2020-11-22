ActiveAdmin.register_page "photographer_maps" do
  menu label: "Ph Map", parent: "Dashboard", priority: 3

  content title: "Ph Maps" do
    columns do
      column do
        panel "مناطق تحت پوشش عکاسان", class: "rtl text-center" do
          columns do
            column do
              render partial: "photographers_map_zone"
            end
          end
        end
      end
    end
  end
end
