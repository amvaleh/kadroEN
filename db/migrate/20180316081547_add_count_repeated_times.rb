class AddCountRepeatedTimes < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :repeated_times, :integer , default: 0
  end
end
