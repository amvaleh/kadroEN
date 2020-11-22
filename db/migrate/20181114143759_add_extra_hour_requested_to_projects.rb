class AddExtraHourRequestedToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :extra_hour_requested, :float
  end
end
