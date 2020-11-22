class CreateBusinesses < ActiveRecord::Migration[5.0]
  def change
    create_table :businesses do |t|
      t.string :name
      t.integer :refers , :default => 0

      t.timestamps
    end
  end
end
