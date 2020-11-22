class CreateCalls < ActiveRecord::Migration[5.0]
  def change
    create_table :calls do |t|
      t.integer :photographer_id
      t.integer :user_id
      t.integer :rate

      t.timestamps
    end
  end
end
