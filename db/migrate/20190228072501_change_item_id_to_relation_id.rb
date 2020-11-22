class ChangeItemIdToRelationId < ActiveRecord::Migration[5.0]
  def change
    rename_column :factor_items, :item_id, :relation_id
  end
end
