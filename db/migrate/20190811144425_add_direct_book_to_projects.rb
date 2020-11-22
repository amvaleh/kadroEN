class AddDirectBookToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :direct_book, :boolean , default: false
  end
end
