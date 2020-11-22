class AddLeadSourceIdToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :lead_source_id, :integer

  end
end
