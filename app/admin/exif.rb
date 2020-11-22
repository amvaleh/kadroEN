ActiveAdmin.register Exif do
  menu parent: "Project", priority: 16
  index do
    selectable_column
    column :id
    column "main source" do |e|
      f = Frame.find_by(:exif_id => e.id)
      p = Photo.find_by(:exif_id => e.id)
      if f.present?
        link_to "project frame", admin_frame_path(f)
      elsif p.present?
        link_to "ph sample photo", admin_photo_path(p)
      else
        "not exists on database."
      end
    end
    column :artist
    column :copyright
    column :camera_model
    column :serial_number
    column :lens
    column :date_created
    column :modify_date
    column :exposure_time
    column :f_number
    column :exposure_program
    column :iso
    column :focal_length
    column :metering_mode
    column :software
    column :exposure
    column :contrast
    column :highlights
    column :shadows
    column :whites
    column :blacks
    column :clarity
    column :saturation
    column :white_balance
    column :color_temperature
    column :tint
    column :sharpness
    column :luminance_smoothing
    column :color_noise_reduction
    column :perspective_vertical
    column :perspective_horizontal
    column :perspective_rotate
    column :perspective_scale
    column :perspective_x
    column :perspective_y
    column :history_action
    column :history_parameters
    column :history_when
    column :history_software_agent
    column :image_size
    column :distortion_correction
    column :vignette_correction
    column :lateral_chromatic_aberration_correction
    actions
  end
end
