class AddFirstCallToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :first_call, :boolean, default: true
  end
end
