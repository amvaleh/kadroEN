class CreateFreeTimesHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :free_times_histories do |t|
      t.integer :day, limit: 1 #tinyint
      t.time :start
      t.time :end
      t.references :photographer, foreign_key: true

      t.timestamps
    end
    add_index :free_times, [:photographer_id, :created_at]
  end
end
