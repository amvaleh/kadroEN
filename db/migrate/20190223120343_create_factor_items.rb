class CreateFactorItems < ActiveRecord::Migration[5.0]
  def change
    create_table :factor_items do |t|
      t.integer :factor_id
      t.integer :item_id
      t.integer :relation_type

      t.timestamps
    end
  end
end
