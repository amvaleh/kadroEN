class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.integer :photographer_id
      t.text :living_address
      t.string :living_long
      t.string :living_lat
      t.string :working_long
      t.string :working_lat
      t.string :living_input
      t.string :working_input

      t.timestamps
    end
  end
end
