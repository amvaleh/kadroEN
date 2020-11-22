class AddSendRequestedForUserToShareControls < ActiveRecord::Migration[5.0]
  def change
    add_column :share_controls, :request_sent_to_user, :boolean , default: false
    add_column :share_controls, :permission_sent_to_photographer, :boolean , default: false
    add_column :share_controls, :last_seen_user, :datetime
  end
end
