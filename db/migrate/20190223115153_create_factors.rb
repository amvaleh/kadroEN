class CreateFactors < ActiveRecord::Migration[5.0]
  def change
    create_table :factors do |t|
      t.string :title
      t.integer :relation_type
      t.integer :factor_type
      t.float :value
      t.integer :value_type
      t.integer :coupon_id

      t.timestamps
    end
  end
end
