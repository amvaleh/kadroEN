class AddBusinessIdToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :business_id, :integer
  end
end
