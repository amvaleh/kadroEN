class GalleriesController < ApplicationController
  before_action :set_gallery, only: [:transfer, :upload_done, :show, :edit, :update, :destroy, :zip_download, :load_more, :load_more_dashboard, :share_list, :share_list_dashboard, :show_dashboard, :exempt_photographer_money]

  include ApplicationHelper

  require "rubygems"
  require "zip"

  devise_group :watcher, contains: [:user, :admin]
  before_action :authenticate_watcher!, only: [:show, :index, :share_list, :share_list_dashboard, :complete_project, :reserved_projects, :not_payed_projects, :show_dashboard, :profile, :update_name, :exempt_photographer_money, :invoices_dashboard]
  layout :resolve_layout

  respond_to :js

  def exempt_photographer_money
    if @gallery.project.user == current_user
      respond_to do |format|
        format.js
      end
    end
  end

  def update_name
    @gallery = Gallery.find_by(slug: params[:gallery_slug])
    if @gallery.project.user == current_user
      @gallery.name = params[:name]
      respond_to do |format|
        if @gallery.save
          format.js
        end
      end
    end
  end

  def single_frame
    @frame = Frame.find_by(:id => params[:frame_id])
    @full_frame = @frame.gallery.project.package.is_full
  end

  def profile
    @user = current_user
  end

  def complete_project
    @permission_error = params[:error]
    @projects = current_user.projects.payed.where(reserve_step_id: 7..17)
    @user = current_user
    @ok_res = "3"
    if params[:result] == "nok"
      @ok_res = "0"
      @res = t(:'invoices.messages.failed_payment')
    elsif params[:result] == "ok"
      @ok_res = "1"
      @res = t(:'invoices.messages.success_payment')
      @track_code = params[:track_code]
    elsif params[:result] == "ok_without_payment"
      @ok_res = "2"
      @res = t(:'invoices.messages.zero_payment_success')
      @notice = "پرداخت با موفقیت از اعتبار کسر شد"
    end

    if params[:tatoken].present? and params[:utm_source] == "takhfifan"
      if current_visit.present?
        current_visit.update_column :utm_term, params[:tatoken]
      end
    end
  end

  def reserved_projects
    @permission_error = params[:error]
    @projects = current_user.projects.payed.where(reserve_step_id: 7..13)
    @user = current_user
    @ok_res = "3"
    if params[:result] == "nok"
      @ok_res = "0"
      @res = t(:'invoices.messages.failed_payment')
    elsif params[:result] == "ok"
      @ok_res = "1"
      @res = t(:'invoices.messages.success_payment')
      @track_code = params[:track_code]
    elsif params[:result] == "ok_without_payment"
      @ok_res = "2"
      @res = t(:'invoices.messages.zero_payment_success')
    end

    if params[:tatoken].present? and params[:utm_source] == "takhfifan"
      if current_visit.present?
        current_visit.update_column :utm_term, params[:tatoken]
      end
    end
  end

  def not_payed_projects
    @permission_error = params[:error]
    @projects = current_user.projects.where(reserve_step_id: [5, 6])
    @user = current_user
    @ok_res = "3"
    if params[:result] == "nok"
      @ok_res = "0"
      @res = t(:'invoices.messages.failed_payment')
    elsif params[:result] == "ok"
      @ok_res = "1"
      @res = t(:'invoices.messages.success_payment')
      @track_code = params[:track_code]
    elsif params[:result] == "ok_without_payment"
      @ok_res = "2"
      @res = t(:'invoices.messages.zero_payment_success')
    end

    if params[:tatoken].present? and params[:utm_source] == "takhfifan"
      if current_visit.present?
        current_visit.update_column :utm_term, params[:tatoken]
      end
    end
  end

  def show_dashboard
    # Rw::Authorize.call(current_user, GalleryPolicy, :show?, @gallery)
    # @full_frame = @gallery.project.package.is_full
    # code

    @user = @gallery.project.user

    unless current_user.id == @user.id ||
           (session[:gallery_authenticated_user] && session[:gallery_authenticated_user]["id"] == current_user.id) ||
           (@gallery.salt.nil? && @gallery.hashed_password.nil?)
      redirect_to controller: "galleries", action: "authenticate_user"
    end
    @user.create_activity :see_his_gallery, owner: current_user, recipient: @gallery
    @need_to_pay_extra_hour = false
    @project = @gallery.project
    if @project.receipt.extrahour_paid < @project.receipt.extrahour_total
      @need_to_pay_extra_hour = true
    end
    @cart_count = Carts::CurrentCartTotal.call(user: current_user).cart_count

    @ok_res = "2"
    if params[:result] == "nok"
      @ok_res = "0"
      @res = t(:'invoices.messages.failed_payment')
    elsif params[:result] == "ok"
      @ok_res = "1"
      @res = t(:'invoices.messages.success_payment')
      @track_code = params[:track_code]
    end

    @favicon = @gallery.project.shoot_type.avatar_url(:large)
    @description = "عکاسی #{@gallery.project.shoot_type.title} با #{@gallery.project.photographer.abbrv_name} در تاریخ #{convert_persian_day(@gallery.project.start_time.strftime("%A")).to_s + " " + @gallery.project.start_time.to_date.to_pdate.strftime("%e %b").to_s + " ساعت " + @gallery.project.start_time.strftime("%H:%M")} به مدت #{@gallery.project.package.duration}. کادرو، اسنپ عکاسی"
  rescue Rw::PermissionError
    redirect_to controller: "galleries", action: "index", error: "permission_error"
  end

  def invoices
    @user = current_user
  end

  def invoices_dashboard
    @user = current_user
  end

  # GET /galleries
  # GET /galleries.json
  def index
    @permission_error = params[:error]
    @projects = current_user.projects
    @user = current_user
    @ok_res = "3"
    if params[:result] == "nok"
      @ok_res = "0"
      @res = t(:'invoices.messages.failed_payment')
    elsif params[:result] == "ok"
      @ok_res = "1"
      @res = t(:'invoices.messages.success_payment')
      @track_code = params[:track_code]
    elsif params[:result] == "ok_without_payment"
      @ok_res = "2"
      @res = t(:'invoices.messages.zero_payment_success')
    end

    if params[:tatoken].present? and params[:utm_source] == "takhfifan"
      if current_visit.present?
        current_visit.update_column :utm_term, params[:tatoken]
      end
    end
  end

  def show
    # Rw::Authorize.call(current_user, GalleryPolicy, :show?, @gallery)
    # @full_frame = @gallery.project.package.is_full
    # code

    @user = @gallery.project.user

    unless current_user.id == @user.id ||
           (session[:gallery_authenticated_user] && session[:gallery_authenticated_user]["id"] == current_user.id) ||
           (@gallery.salt.nil? && @gallery.hashed_password.nil?)
      redirect_to controller: "galleries", action: "authenticate_user"
    end
    @user.create_activity :see_his_gallery, owner: current_user, recipient: @gallery
    @need_to_pay_extra_hour = false
    @project = @gallery.project
    if @project.receipt.extrahour_paid < @project.receipt.extrahour_total
      @need_to_pay_extra_hour = true
    end
    @cart_count = Carts::CurrentCartTotal.call(user: current_user).cart_count

    @ok_res = "2"
    if params[:result] == "nok"
      @ok_res = "0"
      @res = t(:'invoices.messages.failed_payment')
    elsif params[:result] == "ok"
      @ok_res = "1"
      @res = t(:'invoices.messages.success_payment')
      @track_code = params[:track_code]
    end
  rescue Rw::PermissionError
    redirect_to controller: "galleries", action: "index", error: "permission_error"
  end

  def authenticate_user
    @user = Gallery.find_by(slug: params[:id]).project.user
    @id = params[:id]
  end

  def check_password
    result = Galleries::CheckGalleryPassword.call(id: params[:gallery][:id], password: params[:gallery][:password])
    if result.success?
      session[:gallery_authenticated_user] = current_user
      redirect_to controller: "galleries", action: "show_dashboard"
    else
      flash[:error] = "کلمه عبور اشتباه است."
      redirect_to controller: "galleries", action: "authenticate_user"
    end
  end

  def password_form
    @gallery = Gallery.find_by(slug: params[:gallery_id])
    render locals: { gallery_id: params[:gallery_id] }
  end

  def password_create
    gallery = Gallery.find_by(slug: params[:gallery_password][:id])
    Rw::Authorize.call(current_user, GalleryPolicy, :password_create?, gallery)
    result = Galleries::GalleryPasswordCreate.call(id: params[:gallery_password][:id],
                                                   gallery_data: { password: params[:gallery_password][:password],
                                                                   password_confirmation: params[:gallery_password][:password_confirmation] })

    if result.success?
      @gallery = Gallery.find_by(slug: params[:gallery_password][:id])
      @message = "با موفقیت انجام شد."
      current_user.create_activity :set_password_for_gallery, owner: current_user, recipient: @gallery
    else
      Rw::ModelErrors.call(model: result.gallery, class_name: self)
      # @error = result.gallery.errors.messages[:password].join(',')
    end
  rescue Rw::PermissionError
    redirect_to controller: "galleries", action: "index", error: "permission_error"
  end

  def clear_password
    gallery = Gallery.find_by(slug: params[:id])
    Rw::Authorize.call(current_user, GalleryPolicy, :clear_password?, gallery)

    Galleries::ClearPassword.call(id: params[:id])

    @gallery = Gallery.find_by(slug: params[:id])

    current_user.create_activity :cleared_password_of_gallery, owner: current_user, recipient: @gallery

    @message = "با موفقیت انجام شد."
  rescue Rw::PermissionError
    redirect_to controller: "galleries", action: "index", error: "permission_error"
  end

  # GET /galleries/new
  def new
    @gallery = Gallery.new
  end

  def load_more
    if params[:frameNumber]
      frameNumber = params[:frameNumber]
      unless frameNumber.to_i == @gallery.frames.length
        step = (frameNumber.to_i / 9)
        @frames = @gallery.frames.order("created_at DESC").sort_by { |f| f.downloaded? ? 0 : 1 }.in_groups_of(9)[step]
        respond_to do |format|
          format.html
          format.js { render layout: false }
        end
      end
    end
  end

  def load_more_dashboard
    if params[:frameNumber]
      frameNumber = params[:frameNumber]
      unless frameNumber.to_i == @gallery.frames.length
        step = (frameNumber.to_i / 12)
        @frames = @gallery.frames.order(like: :desc, downloaded: :desc, retouched: :desc, created_at: :desc).in_groups_of(12)[step]

        respond_to do |format|
          format.html
          format.js { render layout: false }
        end
      end
    end
  end

  # GET /galleries/1/edit
  def edit
    @photographer = current_photographer
    @project = @gallery.project
  end

  # POST /galleries
  # POST /galleries.json
  def create
    if Project.friendly.find(params[:project][:project_id]).gallery.nil?
      @gallery = Gallery.new(gallery_params)
      @gallery.project = Project.friendly.find(params[:project][:project_id])

      respond_to do |format|
        if @gallery.save
          project = @gallery.project
          project.has_gallery = true
          project.save
          format.html { redirect_to edit_gallery_path(@gallery), notice: "گالری عکس ها ساخته شد، عکس های پروژه را هم اکنون آپلود کنید." }
        else
          format.html { render :back }
        end
      end
    else
      redirect_to :back, notice: "گالری قبلا ساخته شده است."
    end
  end

  # PATCH/PUT /galleries/1
  # PATCH/PUT /galleries/1.json
  def update
    respond_to do |format|
      if @gallery.update(gallery_params)
        format.html { redirect_to @gallery, notice: "Gallery was successfully updated." }
        format.json { render :show, status: :ok, location: @gallery }
      else
        format.html { render :edit }
        format.json { render json: @gallery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /galleries/1
  # DELETE /galleries/1.json
  def destroy
    @gallery.destroy
    respond_to do |format|
      format.html { redirect_to galleries_url, notice: "Gallery was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def upload_done
    if params[:uploaded].present? and params[:uploaded] == "1"
      project = @gallery.project
      project.set_reserve_step("uploaded")
      project.is_uploaded = true
      project.save
      project.set_reserve_step("qualified")
      ph = project.photographer
      if project.save and @gallery.save
        @gallery.project.create_activity :upload_done, owner: current_photographer, recipient: @gallery
        result = Messages::KavenegarSendTemplate.call(mobile_number: ph.mobile_number, token: ph.first_name.tr!(" ", "-"), token2: project.user.disply_name.tr!(" ", "-"), token3: "permission", template: "after-upload-done-gallery-for-photographer")
        if @gallery.project.user_feedback.present?
          redirect_to edit_gallery_path(@gallery), notice: "با تشکر از شما، عکس ها با موفقیت دریافت شد."
        else
          redirect_to user_feedbacks_path(@gallery.project), notice: "با تشکر از شما، عکس ها با موفقیت دریافت شد. لطفا فرم نظرسنجی را تکمیل نمایید."
        end
      end
    end
  end

  def transfer
    params[:file].original_filename = params[:file].original_filename.tr(" ", "_")
    frame = @gallery.frames.find_by(original_filename: params[:file].original_filename)
    if frame.present?
      i = 2
      while frame.present?
        frame = @gallery.frames.find_by(original_filename: "#{i}_" + params[:file].original_filename)
        if !frame.present?
          params[:file].original_filename = "#{i}_" + params[:file].original_filename
        else
          i = i + 1
        end
      end
    end
    @frame = Frame.new(file: params[:file])
    @frame.gallery = @gallery
    @frame.file_name = @frame.file.filename
    @frame.resource_type = "image"
    @frame.tag = @frame.gallery.project.shoot_type.title

    path = @frame.file.file.file
    exif_tool = Exiftool.new(path)
    if exif_tool.errors?
      # head 401
      # ignorin exif erros
      head 200
    else
      exifs = exif_tool.raw
      exif = Exif.create(artist: exifs[:artist], copyright: exifs[:profile_copyright], camera_model: exifs[:model], serial_number: exifs[:serial_number], lens: exifs[:lens], date_created: exifs[:date_created], modify_date: exifs[:modify_date], exposure_time: exifs[:exposure_time], f_number: exifs[:f_number], exposure_program: exifs[:exposure_program], iso: exifs[:iso], focal_length: exifs[:focal_length], metering_mode: exifs[:metering_mode], software: exifs[:software], exposure: exifs[:exposure2012], contrast: exifs[:contrast2012], highlights: exifs[:highlights2012], shadows: exifs[:shadows2012], whites: exifs[:whites2012], blacks: exifs[:blacks2012], clarity: exifs[:clarity2012], saturation: exifs[:saturation], white_balance: exifs[:white_balance], color_temperature: exifs[:color_temperature], tint: exifs[:tint], sharpness: exifs[:sharpness], luminance_smoothing: exifs[:luminance_smoothing], color_noise_reduction: exifs[:color_noise_reduction], perspective_vertical: exifs[:perspective_vertical], perspective_horizontal: exifs[:perspective_horizontal], perspective_rotate: exifs[:perspective_rotate], perspective_scale: exifs[:perspective_scale], perspective_x: exifs[:perspective_x], perspective_y: exifs[:perspective_y], history_action: exifs[:history_action], history_parameters: exifs[:history_parameters], history_when: exifs[:history_when], history_software_agent: exifs[:history_software_agent], image_size: exifs[:image_size], vignette_correction: exifs[:vignette_correction_already_applied], distortion_correction: exifs[:distortion_correction_already_applied], lateral_chromatic_aberration_correction: exifs[:lateral_chromatic_aberration_correction_already_applied])
      @frame.exif = exif
      if current_admin_user.present?
        @frame.limit = 30000000
      elsif current_photographer.present?
        @frame.limit = 20000000
      end

      if @frame.save
        if current_photographer.present?
          current_photographer.create_activity :ph_upload_frame, owner: @frame.gallery, recipient: @frame
        else
          current_admin_user.create_activity :ph_upload_frame, owner: @frame.gallery, recipient: @frame
        end
        head 200
      else
        @errors = @frame.errors.messages[:size][0]
        head 406
      end
    end
  end

  def zip_download
    @project = @gallery.project

    unless @project.feed_back.present?
      @show_feed_back_modal = true
    end

    if @project.reserve_step.name == "qualified" or @project.reserve_step.name == "downloaded" or @project.reserve_step.name == "uploaded"
      @show_exemption_modal = true
    end

    unless @show_feed_back_modal or @show_exemption_modal
      public_ids = []
      count = @gallery.frames.where(:downloaded => true).count
      if @gallery.downloading_zip == false # if gallery is not being downloaded in another thread.
        @gallery.downloading_zip = true
        @gallery.save
        i = 0
        @frames = []
        if @gallery.project.package.is_full # if package is full
          @frames = @gallery.frames
        else # if package is not full and should be selected
          @frames = @gallery.frames.where(:downloaded => true)
        end
        # cloudinary storage
        begin
          if @frames.first.public_id.present?
            @frames.each do |f|
              i = i + 1
              public_ids << f.public_id.to_s
              if i != count
                public_ids << ","
              end
            end
            if @frames.count > 0
              @url = Cloudinary::Utils.download_zip_url(:public_ids => public_ids, :resource_type => "image", allow_missing: true)
            end
          else
            # server storage
            # folder = "public/zips/gallery/#{@gallery.slug}"

            create_folder_for_gallery = `mkdir -p public/uploads/frames/zip/gallery/#{@gallery.slug}`
            give_permission = `chmod -R a+rwx public/uploads/frames/zip/gallery/#{@gallery.slug}`
            zipfolder_path = "public/uploads/frames/zip/gallery/#{@gallery.slug}/"
            zipname = "#{@frames.count}files-#{@gallery.project.user.mobile_number}.zip"
            zipfile_name = zipfolder_path + zipname
            if File.exist?(zipfile_name)
              FileUtils.rm_rf zipfile_name
            end
            Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
              # Two arguments:
              # - The name of the file as it will appear in the archive
              # - The original file, including the path to find it
              @frames.each do |fr|
                if fr.downloaded == false
                  fr.downloaded = true
                end
                puts fr.file_url
                puts fr.file_name
                path = File.join("#{Rails.root}/public/", fr.file_url)
                corrected_original_filename = fr.original_filename.downcase.tr(" ", "_")
                filename = corrected_original_filename
                if File.exist?("#{Rails.root}/public#{fr.file_url}")
                  begin
                    zipfile.add(filename, path)
                  rescue Zip::ZipEntryExistsError
                  end
                end
              end
              zipfile.get_output_stream("kadro.txt") { |f| f.write "تمام عکس هایی که خریداری کرده اید در این پوشه قراردارد. تیم کادرو" }
            end
            give_permission = `chmod -R a+rwx public/uploads/frames/zip/gallery/#{@gallery.slug}`

            if Rails.env.production?
              base = "https://app.kadro.co/"
            elsif Rails.env.development?
              base = "http://app.localhost:3000/"
            elsif Rails.env.staging?
              base = "http://185.53.143.141:3005/"
            end
            @url = base + "uploads/frames/zip/gallery/#{@gallery.slug}/" + zipname
            @gallery.zip_url = "uploads/frames/zip/gallery/#{@gallery.slug}/" + zipname
          end
          @gallery.downloading_zip = false
          @gallery.downloaded_count = @frames.count
          @gallery.save
          project = @gallery.project
          if project.reserve_step.name == "re_edit" || project.reserve_step.name == "qualified" || project.reserve_step.name == "uploaded"
            Projects::Update.call(id: @gallery.project_id,
                                  data: { reserve_step_id: ReserveStep.where(name: "downloaded").pluck(:id)[0] })
          end
          @gallery.project.user.create_activity :downloaded_all, owner: current_user, recipient: @gallery
        ensure
          @gallery.downloading_zip = false
          @gallery.zip_created_at = Time.now
          @gallery.save
          puts @url
          short_url = Shortener::ShortenedUrl.generate(@gallery.zip_url)
          sms_message = <<-text
کادرویی عزیز،
لینک دانلود فایل فشرده عکس ها که خواسته بودید:
http://l.kadro.co/#{short_url.unique_key}
بعد از یک هفته لینک منقضی خواهد شد
تیم کادرو
          text
          SmsWorker.perform_async(sms_message, current_user.mobile_number)
          if current_user.email.present?
            EmailSendUrlZipFileDownloadWorker.perform_async(@project.id)
          end
        end
      end
    end
    respond_to do |format|
      format.js { }
    end
  end

  def download_receipt
    @user = current_user
    html = render_to_string(partial: "invoice_receipt.html.erb", locals: { cart_id: params[:cart_id] })
    kit = PDFKit.new(html, page_size: "A3")
    kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/kadro/bootstrap.min.css"
    kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/kadro/bootstrap-rtl.min.css"
    kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/kadro/kadro.css"
    kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/pdfstyle.css"

    directory_name = "#{Rails.root}/public/uploads/receipts"
    unless File.exist?(directory_name)
      Dir.mkdir(directory_name)
    end

    pdf = kit.to_file("#{Rails.root}/public/uploads/receipts/invoice#{params[:cart_id]}.pdf")
    send_file("#{Rails.root}/public/uploads/receipts/invoice#{params[:cart_id]}.pdf")

    cart = Cart.find(params[:cart_id])

    @user.create_activity :downloaded_receipt, owner: current_user, recipient: cart
  end

  def receipt_modal
    @cart_id = params[:cart_id]
    respond_to do |format|
      format.js
    end
  end

  def receipt_modal_dashboard
    @cart_id = params[:cart_id]
    respond_to do |format|
      format.js
    end
  end

  def share_list
    @user = @gallery.project.user
    @frames = @gallery.frames
    @frames.share_requested.each do |frame|
      frame.share_control.last_seen_user = Time.now
      frame.share_control.save
    end
  end

  def share_list_dashboard
    @user = @gallery.project.user
    @frames = @gallery.frames
    @frames.share_requested.each do |frame|
      frame.share_control.last_seen_user = Time.now
      frame.share_control.save
    end
  end

  private

  def resolve_layout
    case action_name
    when "share_list"
      "gallery"
    when "show"
      "gallery"
    when "index"
      "gallery"
    when "complete_project"
      "dashboard"
    when "reserved_projects"
      "dashboard"
    when "not_payed_projects"
      "dashboard"
    when "show_dashboard"
      "dashboard"
    when "invoices_dashboard"
      "dashboard"
    when "profile"
      "dashboard"
    when "share_list_dashboard"
      "dashboard"
    when "authenticate_user"
      "gallery"
    when "invoices"
      "gallery"
    else
      "photographer"
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_gallery
    @gallery = Gallery.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def gallery_params
    params.fetch(:gallery, {})
  end
end
