class AddCallDateAndIsCalledToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :call_date, :date
    add_column :users, :is_called, :boolean, default: true
  end
end
