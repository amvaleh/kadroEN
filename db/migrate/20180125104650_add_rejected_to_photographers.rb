class AddRejectedToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :rejected, :boolean , default: false
  end
end
