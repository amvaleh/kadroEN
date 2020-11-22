class AddCallStatusIdToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :call_status_id, :integer
  end
end
