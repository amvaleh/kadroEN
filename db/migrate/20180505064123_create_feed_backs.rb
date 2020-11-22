class CreateFeedBacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feed_backs do |t|
      t.integer :project_id
      t.integer :qrate
      t.integer :arate
      t.string :description
      t.timestamps
    end
    add_index :feed_backs, :project_id
  end
end
