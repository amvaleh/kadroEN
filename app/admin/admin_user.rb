ActiveAdmin.register AdminUser do
  menu parent: "General Settings", priority: 2
  permit_params :email, :password, :password_confirmation, :role, :gender, :position, :avatar, :first_name, :last_name, :about_position, :about_description, :about_instagram, :about_twitter, :about_linkedin, :about_display
  #

  filter :role
  filter :gender
  filter :first_name
  filter :last_name
  form do |f|
    f.inputs "Status" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :role
      f.input :gender
    end
    f.inputs "About" do
      f.input :first_name
      f.input :last_name
      f.input :about_description
      f.input :about_position
      f.input :about_instagram
      f.input :about_linkedin
      f.input :about_twitter
      f.input :avatar, as: :file
      f.input :about_display
    end
    f.actions
  end
  controller do
    def update
      model = :admin_user
      if params[model][:password].blank?
        %w(password password_confirmation).each { |p| params[model].delete(p) }
      end
      super
    end
  end
end
