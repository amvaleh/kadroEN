class AddChangeLoopTimesToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :change_loop_times, :integer
  end
end
