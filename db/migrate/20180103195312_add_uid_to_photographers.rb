class AddUidToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :uid, :string
    connection.execute('update photographers set uid = mobile_number')
  end
end
