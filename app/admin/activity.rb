ActiveAdmin.register_page "Activities" do
  menu parent: "Dashboard", priority: 4
  content tiltle: "Activities" do
    columns do
      column do
        panel "فعالیت ها", class: "rtl text-right" do
          columns do
            column do
              activities = PublicActivity::Activity.where(:created_at => (Date.today.beginning_of_day)..(Date.today.end_of_day)).order(created_at: :desc)
              render partial: "activity_page", locals: { activities: activities }
            end
          end
        end
      end
    end
  end
end
