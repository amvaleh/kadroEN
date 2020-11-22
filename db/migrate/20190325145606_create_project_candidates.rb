class CreateProjectCandidates < ActiveRecord::Migration[5.0]
  def change
    create_table :project_candidates do |t|
      t.integer :project_id
      t.integer :photographer_id
      t.integer :project_candidate_status_id
      t.integer :priority
      t.float :distance
      t.float :price
      t.timestamps
    end
    add_foreign_key(:project_candidates, :projects, column: :project_id, index: true)
    add_foreign_key(:project_candidates, :photographers, column: :photographer_id, index: true)
  end
end
