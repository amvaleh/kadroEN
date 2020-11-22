class RenameInStudioToIsStudioForShootLocations < ActiveRecord::Migration[5.0]
  def change
    rename_column :shoot_locations, :in_studio, :is_studio
  end
end
