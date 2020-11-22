class AddApprovedToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :approved, :boolean , default: false
  end
end
