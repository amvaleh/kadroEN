class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :longtitude
      t.string :lattitude
      t.string :input
      t.integer :project_id

      t.timestamps
    end
  end
end
