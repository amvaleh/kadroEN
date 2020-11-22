class CreateStartHours < ActiveRecord::Migration[5.0]
  def change
    create_table :start_hours do |t|
      t.string :title
      t.integer :day_time_id

      t.timestamps
    end
  end
end
