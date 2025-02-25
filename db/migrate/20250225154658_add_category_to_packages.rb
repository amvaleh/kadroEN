class AddCategoryToPackages < ActiveRecord::Migration[5.0]
  def change
    add_column :packages, :category, :string
  end
end
