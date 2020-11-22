class AddAssignedAtToProjectCandidates < ActiveRecord::Migration[5.0]
  def change
    add_column :project_candidates, :assigned_at, :datetime
  end
end
