class ChangeOrderInPackages < ActiveRecord::Migration[5.0]
  def change
    change_column :packages, :order, :float
  end
end
