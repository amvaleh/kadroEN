class ChangeInvitationName < ActiveRecord::Migration[5.0]
  def change
    rename_table :invitations, :refers
  end
end
