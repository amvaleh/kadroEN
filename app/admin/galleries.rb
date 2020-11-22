ActiveAdmin.register Gallery do
  menu priority: 6
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :download_limit, :downloaded_count, :admin_user, :total_frames, :zip_created_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  before_action :log_activities, only: [:destroy]

  controller do
    def log_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: Gallery.find_by(slug: params[:id])
    end
  end

  collection_action :select_frame_form, method: :get do
    data = SelectableImages::SelectShootTypes.call(image_id: params[:image_id], image_type: params[:image_type])
    render locals: { image_id: params[:image_id], shoot_types: data.shoot_types, image_type: params[:image_type] }
  end

  collection_action :select_frame, method: :post do
    Galleries::SelectedImageShootTypesCreate.call(image: params[:select_frame][:image_type],
                                                  shoot_types: params[:select_frame][:shoot_types],
                                                  image_id: params[:select_frame][:image_id],
                                                  description: params[:select_frame][:description])
  end

  index :title => "گالری ها" do
    selectable_column
    column :id
    column :project
    column :slug
    column :download_limit
    column :downloaded_count
    column :total_frames
    column :zip_created_at
    column :created_at
    column :updated_at
    actions
  end

  show do
    div span: 2 do
      attributes_table do
        row :project
        row :slug
        row :zip_created_at
        row :created_at
        row :updated_at
        row :updated_at
        row :download_limit
        row :downloaded_count
        row :total_frames
        row "uploaded frames" do |f|
          f.frames.count
        end
        row "short UTMed url" do |f|
          f.short_url
        end
        row :zip_created_at
        row :zip_url
      end
    end

    panel "Upload", :class => "h4" do
      render partial: "uploader_gallery_admin", locals: { :@gallery => gallery }
    end

    panel "Frames", :class => "h4" do
      @frames = gallery.frames
      context = Admins::CheckAdminGender.call(slug: params[:id], admin: current_admin_user)
      if context.access
        render partial: "frames", locals: { frames: @frames }
      else
        "No access"
      end
    end

    active_admin_comments
  end

  form :class => "form-control" do |f|
    f.input :admin_user, input_html: { value: "#{current_admin_user.id}" }, as: :hidden

    f.inputs "Status" do
      f.input :download_limit
      f.input :downloaded_count
      f.input :total_frames
      f.input :zip_created_at, as: :date_time_picker
      f.input :zip_url
    end
    f.actions
  end

  batch_action :'Clear Password' do |ids|
    batch_action_collection.find(ids).each do |gallery|
      Galleries::ClearPassword.call(id: gallery.slug)
    end
    redirect_to collection_path, notice: "Successful."
  end
end
