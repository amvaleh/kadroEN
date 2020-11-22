class AddReserveStepIdToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :reserve_step_id, :integer
  end
end
