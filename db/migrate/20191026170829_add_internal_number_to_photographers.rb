class AddInternalNumberToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :internal_number, :integer
  end
end
