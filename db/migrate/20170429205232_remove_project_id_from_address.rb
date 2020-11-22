class RemoveProjectIdFromAddress < ActiveRecord::Migration[5.0]
  def change
    remove_column :addresses, :project_id
  end
end
