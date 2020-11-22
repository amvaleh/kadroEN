class CreateCoupons < ActiveRecord::Migration[5.0]
  def change
    create_table :coupons do |t|
      t.string :title
      t.integer :value
      t.boolean :is_percent

      t.timestamps
    end
  end
end
