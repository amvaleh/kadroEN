class GalleryMailer < ApplicationMailer

  def send_url_zip_file_download(slug)
    @project = Project.friendly.find(slug)
    @user = @project.user
    @gallery = @project.gallery
    if @user.email.present?
      @email = @project.user.email
      mail(to: @user.email, subject: "لینک دانلود فایل فشرده عکس های گالری شما")
      @user.create_activity :send_url_zip_file_download
    end
  end

end
