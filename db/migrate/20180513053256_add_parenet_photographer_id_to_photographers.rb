class AddParenetPhotographerIdToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :parent_photographer_id, :integer
  end
end
