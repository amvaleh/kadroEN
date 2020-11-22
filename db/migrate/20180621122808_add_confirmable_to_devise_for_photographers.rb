class AddConfirmableToDeviseForPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :confirmation_token, :string
    add_column :photographers, :confirmed_at, :datetime
    add_column :photographers, :confirmation_sent_at, :datetime
    add_column :photographers, :unconfirmed_email, :string
    # add_column :photographers, :unconfirmed_email, :string # Only if using reconfirmable
    add_index :photographers, :confirmation_token, unique: true
    # User.reset_column_information # Need for some types of updates, but not for update_all.
    # To avoid a short time window between running the migration and updating all existing
    # photographers as confirmed, do the following
    Photographer.all.update_all confirmed_at: DateTime.now
    # All existing user accounts should be able to log in after this.
  end
end
