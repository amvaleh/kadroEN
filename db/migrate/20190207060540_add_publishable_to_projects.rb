class AddPublishableToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :publishable, :boolean
  end
end
