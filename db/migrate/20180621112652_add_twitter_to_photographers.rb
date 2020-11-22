class AddTwitterToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :twitter, :string
  end
end
