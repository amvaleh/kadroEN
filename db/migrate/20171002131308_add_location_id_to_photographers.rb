class AddLocationIdToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :location_id, :integer
    remove_column :locations , :photographer_id
  end
end
