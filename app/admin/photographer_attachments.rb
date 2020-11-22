ActiveAdmin.register PhotographerAttachment do
  before_action :log_activities, only: :destroy
  controller do
    def log_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: PhotographerAttachment.find(params[:id])
    end
  end

  menu parent: "Photographer", priority: 10
  index do
    selectable_column
    column :id
    column :photographer
    column :avatar
    column "light" do |f|
      link_to f.avatar_url(:large), :target => "_blank" do
        image_tag f.avatar_url(:large), :width => 100
      end
    end
    column :created_at
    column :updated_at
    actions
  end
end
