class AddAutoBookToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :auto_book, :boolean , default: true
  end
end
