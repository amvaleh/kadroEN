class AddAdminUserIdToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :admin_user_id, :integer
  end
end
