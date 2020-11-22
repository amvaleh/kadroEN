class AddUsedMaskToFeedBacks < ActiveRecord::Migration[5.0]
  def change
    add_column :feed_backs, :used_mask, :boolean, default: false
  end
end
