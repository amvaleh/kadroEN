class AddSlugToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :slug, :string
    add_index :photographers, :slug, unique: true
  end
end
