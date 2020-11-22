class CreateLookups < ActiveRecord::Migration[5.0]
  def change
    create_table :lookups do |t|
      t.string :category
      t.integer :code
      t.string :title

      t.timestamps
    end
  end
end
