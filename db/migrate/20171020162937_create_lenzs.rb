class CreateLenzs < ActiveRecord::Migration[5.0]
  def change
    create_table :lenzs do |t|
      t.string :brand
      t.string :model

      t.timestamps
    end
  end
end
