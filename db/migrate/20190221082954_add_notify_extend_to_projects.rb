class AddNotifyExtendToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :notify_extend, :boolean
  end
end
