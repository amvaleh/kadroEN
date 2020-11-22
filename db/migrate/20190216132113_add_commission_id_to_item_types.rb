class AddCommissionIdToItemTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :item_types, :commission_id, :integer
  end
end
