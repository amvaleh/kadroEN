class AddSeqToItemTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :item_types, :seq, :integer
  end
end
