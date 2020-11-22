class AddOpenedToSentPhotographerEmails < ActiveRecord::Migration[5.0]
  def change
    add_column :sent_photographer_emails, :opened, :boolean , default: false
  end
end
