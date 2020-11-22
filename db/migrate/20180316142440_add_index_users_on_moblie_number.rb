class AddIndexUsersOnMoblieNumber < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :mobile_number, unique: true
  end
end
