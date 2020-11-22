class AddPasswordSentTimesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :password_sent_times, :integer , default: 0
  end
end
