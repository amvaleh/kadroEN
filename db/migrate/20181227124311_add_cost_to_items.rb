class AddCostToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :cost, :float
  end
end
