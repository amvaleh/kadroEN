class AddOrderToPackages < ActiveRecord::Migration[5.0]
  def change
    add_column :packages, :order, :integer
  end
end
