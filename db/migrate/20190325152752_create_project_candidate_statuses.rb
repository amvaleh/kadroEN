class CreateProjectCandidateStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :project_candidate_statuses do |t|
      t.string :title
      t.timestamps
    end
  end
end
