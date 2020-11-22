class AddFirstNameToAdminUser < ActiveRecord::Migration[5.0]
  def change
    add_column :admin_users, :avatar, :string
    add_column :admin_users, :first_name, :string
    add_column :admin_users, :last_name, :string
    add_column :admin_users, :about_position, :string
    add_column :admin_users, :about_description, :string
    add_column :admin_users, :about_instagram, :string
    add_column :admin_users, :about_twitter, :string
    add_column :admin_users, :about_linkedin, :string
    add_column :admin_users, :about_display, :boolean , default: false
  end
end
