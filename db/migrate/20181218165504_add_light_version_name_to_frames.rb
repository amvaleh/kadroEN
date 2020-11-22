class AddLightVersionNameToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :light_version_name, :string
  end
end
