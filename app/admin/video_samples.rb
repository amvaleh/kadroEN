ActiveAdmin.register VideoSample do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :video_source, :cameras_count, :helishot, :scenario, :output_length, :edit_level, :project_length, :price, :eng_title, :video_poster
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :video_source, :cameras_count, :helishot, :scenario, :output_length, :edit_level, :project_length, :price]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  #
  form(:html => { :multipart => true }) do |f|
    f.input :video_source, as: :file
    f.input :video_poster, as: :file
    f.input :title
    f.input :eng_title
    f.input :cameras_count
    f.input :helishot
    f.input :scenario
    f.input :output_length
    f.input :edit_level
    f.input :project_length
    f.input :price
    f.actions
  end
end
