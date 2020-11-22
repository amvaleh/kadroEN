class AddPublishableToFeedBacks < ActiveRecord::Migration[5.0]
  def change
    add_column :feed_backs, :publishable, :boolean , default: true
  end
end
