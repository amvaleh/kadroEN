# This migration comes from lines (originally 20150421093311)
class AddResetPasswordFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :lines_users, :reset_digest, :string
    add_column :lines_users, :reset_sent_at, :datetime
  end
end
