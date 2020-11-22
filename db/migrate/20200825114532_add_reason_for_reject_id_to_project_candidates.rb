class AddReasonForRejectIdToProjectCandidates < ActiveRecord::Migration[5.0]
  def change
    add_column :project_candidates, :reason_for_reject_id, :integer
  end
end
