class CreatePackages < ActiveRecord::Migration[5.0]
  def change
    create_table :packages do |t|
      t.string :title
      t.string :duration
      t.string :price
      t.integer :digitals
      t.string :exta_price
      t.integer :shoot_type_id

      t.timestamps
    end
  end
end
