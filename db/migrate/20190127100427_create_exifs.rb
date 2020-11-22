class CreateExifs < ActiveRecord::Migration[5.0]
  def change
    create_table :exifs do |t|
      t.string :artist
      t.string :copyright
      t.string :camera_model
      t.string :serial_number
      t.string :lens
      t.string :date_created
      t.string :modify_date
      t.string :exposure_time
      t.string :f_number
      t.string :exposure_program
      t.string :iso
      t.string :focal_length
      t.string :metering_mode
      t.string :software
      t.string :exposure
      t.string :contrast
      t.string :highlights
      t.string :shadows
      t.string :whites
      t.string :blacks
      t.string :clarity
      t.string :saturation
      t.string :white_balance
      t.string :color_temperature
      t.string :tint
      t.string :sharpness
      t.string :luminance_smoothing
      t.string :color_noise_reduction
      t.string :perspective_vertical
      t.string :perspective_horizontal
      t.string :perspective_rotate
      t.string :perspective_scale
      t.string :perspective_x
      t.string :perspective_y
      t.text :history_action
      t.text :history_parameters
      t.text :history_when
      t.string :history_software_agent
      t.string :image_size

      t.timestamps
    end
  end
end
