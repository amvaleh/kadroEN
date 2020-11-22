class AddPromissoryToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :promissory, :boolean
  end
end
