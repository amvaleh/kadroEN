class AddConfirmedToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :confirmed, :boolean
  end
end
