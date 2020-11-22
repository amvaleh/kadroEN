class RenameLightVersionNameColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column(:frames, :light_version_name, :light_version_slug)
  end
end
