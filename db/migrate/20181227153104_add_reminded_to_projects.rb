class AddRemindedToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :reminded, :boolean, deafult: false
  end
end
