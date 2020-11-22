class AddHasStudioToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :has_studio, :boolean , default: false
  end
end
