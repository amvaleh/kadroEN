class AddOneTimeVisitToGoalToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :one_time_visit_to_goal, :boolean , default: false
  end
end
