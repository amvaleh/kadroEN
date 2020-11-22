class AddColumnsToExifs < ActiveRecord::Migration[5.0]
  def change
    add_column :exifs, :distortion_correction, :string
    add_column :exifs, :vignette_correction, :string
    add_column :exifs, :lateral_chromatic_aberration_correction, :string
  end
end
