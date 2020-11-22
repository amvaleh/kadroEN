class AddCategoryToItemTypes < ActiveRecord::Migration[5.0]
  def change
    add_column(:item_types, :category, :string)
  end
end
