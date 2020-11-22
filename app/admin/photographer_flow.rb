ActiveAdmin.register_page "Photographer Flow" do
  menu label: "Ph Flow"
  menu priority: 7
  content do
    div style: 'width: 3000px'  do
      render 'admin/photographers/photographer_flow'
    end
  end
end
