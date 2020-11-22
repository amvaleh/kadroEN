class AddCheckedToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :checked, :boolean
  end
end
