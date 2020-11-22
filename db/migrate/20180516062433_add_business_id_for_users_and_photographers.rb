class AddBusinessIdForUsersAndPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :business_id, :integer
    add_column :photographers, :business_id, :integer
    add_column :businesses, :admin_user_id, :integer
  end
end
