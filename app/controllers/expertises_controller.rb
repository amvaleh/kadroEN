class ExpertisesController < ApplicationController
  def receive_photo
    @photographer = Photographer.find(params[:photographer_id])
    @photo = Photo.new(file: params[:file])
    path = @photo.file.file.file
    exif_tool = Exiftool.new(path)
    exifs = exif_tool.raw
    exif = Exif.create(artist: exifs[:artist], copyright: exifs[:profile_copyright], camera_model: exifs[:model], serial_number: exifs[:serial_number], lens: exifs[:lens], date_created: exifs[:date_created], modify_date: exifs[:modify_date], exposure_time: exifs[:exposure_time], f_number: exifs[:f_number], exposure_program: exifs[:exposure_program], iso: exifs[:iso], focal_length: exifs[:focal_length], metering_mode: exifs[:metering_mode], software: exifs[:software], exposure: exifs[:exposure2012], contrast: exifs[:contrast2012], highlights: exifs[:highlights2012], shadows: exifs[:shadows2012], whites: exifs[:whites2012], blacks: exifs[:blacks2012], clarity: exifs[:clarity2012], saturation: exifs[:saturation], white_balance: exifs[:white_balance], color_temperature: exifs[:color_temperature], tint: exifs[:tint], sharpness: exifs[:sharpness], luminance_smoothing: exifs[:luminance_smoothing], color_noise_reduction: exifs[:color_noise_reduction], perspective_vertical: exifs[:perspective_vertical], perspective_horizontal: exifs[:perspective_horizontal], perspective_rotate: exifs[:perspective_rotate], perspective_scale: exifs[:perspective_scale], perspective_x: exifs[:perspective_x], perspective_y: exifs[:perspective_y], history_action: exifs[:history_action], history_parameters: exifs[:history_parameters], history_when: exifs[:history_when], history_software_agent: exifs[:history_software_agent], image_size: exifs[:image_size], vignette_correction: exifs[:vignette_correction_already_applied], distortion_correction: exifs[:distortion_correction_already_applied], lateral_chromatic_aberration_correction: exifs[:lateral_chromatic_aberration_correction_already_applied])
    @photo.exif = exif
    @photo.save

    shoot_type = params[:shoot_type_id]
    expertise = Expertise.where(:shoot_type => ShootType.find(shoot_type), :photographer => @photographer).first
    if expertise
      @photo.expertise = expertise
    else
      expertise = Expertise.new
      expertise.photographer = @photographer
      expertise.shoot_type = ShootType.find(shoot_type)
      expertise.save
      @photo.expertise = expertise
    end
    respond_to do |format|
      if @photo.save
        format.html {
          render :json => [@photo.to_jq_upload].to_json,
                 :content_type => 'text/html',
                 :layout => false
        }
        format.json {render json: {files: [@photo.to_jq_upload]}, status: :created, location: @photo.file_url(:medium)}
      else
        format.html {render action: "new"}
        format.json {render json: @photo.errors, status: :unprocessable_entity}
      end
    end
  end
end
