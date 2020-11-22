class AddGenderToAdminUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :admin_users, :gender, :integer, default: 2
  end
end
