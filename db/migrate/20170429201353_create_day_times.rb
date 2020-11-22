class CreateDayTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :day_times do |t|
      t.string :title

      t.timestamps
    end
  end
end
