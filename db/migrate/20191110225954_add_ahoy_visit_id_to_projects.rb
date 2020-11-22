class AddAhoyVisitIdToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :ahoy_visit_id, :bigint
  end
end
